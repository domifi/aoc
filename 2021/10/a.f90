module char_stack
    implicit none
    private

    type, public :: t_elem
        sequence
        character :: c
    end type

    type, public :: t_stack
        integer, private :: head
        type(t_elem), private :: arr(200)
    contains
        procedure, public :: push,pop,peek,stack_size
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

end module char_stack

program aoc21_10a
    use char_stack
    implicit none

    integer, parameter :: FID = 9
    integer :: IERR = 0
    integer :: ARG_LEN ! how long the arg (path is)
    character(200) :: TMP_STR
    character(200) :: TMP_STR2 ! somewhere to read the lines to
    character :: TMP(200)
    character(:), allocatable :: PATH
    integer :: I



    ! check number of cli arguments and get the argument:
    if (command_argument_count() /= 1) THEN
        call get_command_argument(number=0, value=TMP_STR)
        print *, "Usage: "//trim(TMP_STR)//" input_file"
        stop
    else
        call get_command_argument(number=1, length=ARG_LEN)
        allocate(character(ARG_LEN) :: PATH)
        call get_command_argument(number=1, value=PATH)
    end if

    open(FID, file=PATH)

    do while (IERR == 0)
        read(FID, *, iostat=IERR) TMP_STR
        TMP(:) = TMP_STR(:)
        write(TMP_STR2, *) len_trim(TMP_STR)
        read(TMP_STR, "("//trim(adjustl(TMP_STR2))//"(A))")
        print *, TMP
    end do


    close(FID)


end program aoc21_10a
