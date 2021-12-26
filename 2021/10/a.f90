module char_stack
    implicit none
    private

    type, public :: t_elem
        sequence
        character :: c
    end type

    type, public :: t_stack
        integer, private :: head = 1
        type(t_elem), private :: arr(200)
    contains
        procedure, public :: push,pop,peek,stack_size,clear
    end type


contains
    subroutine push(self, c)
        implicit none
        class(t_stack), intent(inout) :: self
        character, intent(in) :: c
        type(t_elem) :: elem

        elem = t_elem(c)
        self%head = self%head + 1
        self%arr(self%head) = elem
    end subroutine push

    function peek(self) result(elem)
        implicit none
        class(t_stack), intent(in) :: self
        type(t_elem) :: elem
        if (self%head >= 1) then
            elem = self%arr(self%head)
        else
            !write(*,*) "Tried to access empty stack. Exiting"
            call exit(1)
        end if
    end function peek

    function pop(self) result(elem)
        implicit none
        class(t_stack), intent(inout) :: self
        type(t_elem) :: elem

        if (self%head >= 1) then
            elem = self%peek()
            self%head = self%head - 1
        else
            !write(*,*) "Tried to access full stack. Exiting"
            call exit(1)
        end if
    end function pop

    pure function stack_size(self) result(n)
        implicit none
        class(t_stack), intent(in) :: self
        integer :: n
        n = self%head
    end function stack_size

    subroutine clear(self)
        implicit none
        class(t_stack), intent(inout) :: self
        self%head = 1
    end subroutine clear

end module char_stack

module my_mod
    implicit none

contains
    elemental function get_score(char) result(n)
        implicit none
        character, intent(in) :: char
        integer :: n

        if (char == ')') then
            n = 3
        else if (char == ']') then
            n = 57
        else if (char == '}') then
            n = 1197
        else if (char == '>') then
            n = 25137
        else
            n = 0
        end if
    end function get_score

    elemental function matching(c1, c2) result(b)
        implicit none
        character, intent(in) :: c1, c2
        logical :: b
        b =      (c1 == '(' .and. c2 == ')') &
            .or. (c1 == '[' .and. c2 == ']') &
            .or. (c1 == '{' .and. c2 == '}') &
            .or. (c1 == '<' .and. c2 == '>')
    end function matching
end module my_mod

program aoc21_10a
    use char_stack
    use my_mod
    implicit none

    integer, parameter :: FID = 9
    integer :: IERR = 0
    integer :: ARG_LEN ! how long the arg (path is)
    character(200) :: TMP
    character(:), allocatable :: PATH
    integer :: I, J

    integer :: num_lines = -1
    character, allocatable :: input(:,:)
    integer :: score
    type(t_stack) :: stack
    type(t_elem) :: current


    ! check number of cli arguments and get the argument:
    if (command_argument_count() /= 1) THEN
        call get_command_argument(number=0, value=TMP)
        print *, "Usage: "//trim(TMP)//" input_file"
        stop
    else
        call get_command_argument(number=1, length=ARG_LEN)
        allocate(character(ARG_LEN) :: PATH)
        call get_command_argument(number=1, value=PATH)
    end if

    open(FID, file=PATH)

    ! find out number of lines:
    do while (IERR == 0)
        num_lines = num_lines + 1
        read(FID, *, iostat=IERR) TMP
    end do

    ! read into character array
    rewind(FID)
    allocate(character :: input(200, num_lines))
    input = ' '
    do I = 1, num_lines
        read(FID, "(A)") TMP
        forall (J=1:len_trim(TMP)) input(J,I) = TMP(J:J)
    end do

    close(FID)

    ! push line to stack
    score = 0
    do I = 1, num_lines
        do J = 1, count(input(:,I) /= ' ')
            if (index("([{<", input(J,I)) /= 0) then ! if current character is any opening symbol
                call stack%push(input(J,I))
            else ! else must be closing
                current = stack%pop()
                if (.not. matching(current%c, input(J,I))) then
                    score = score + get_score(input(J,I))
                    call stack%clear
                    exit
                end if
            end if
        end do
    end do

    print *, score

end program aoc21_10a
