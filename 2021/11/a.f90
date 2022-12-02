module pair_stack
    implicit none
    private

    type, public :: t_elem
        sequence
        integer :: x,y
    end type

    type, public :: t_stack
        integer, private :: head
        type(t_elem), private :: arr(1000)
    contains
        procedure, public :: push,pop,peek,stack_size
    end type


contains
    subroutine push(self, x,y)
        implicit none
        class(t_stack), intent(inout) :: self
        integer, intent(in) :: x,y
        type(t_elem) :: pair

        pair = t_elem(x,y)
        self%head = self%head + 1
        self%arr(self%head) = pair
    end subroutine push

    function peek(self) result(pair)
        implicit none
        class(t_stack), intent(in) :: self
        type(t_elem) :: pair
        if (self%head >= 1) then
            pair = self%arr(self%head)
        else
            !write(*,*) "Tried to access empty stack. Exiting"
            call exit(1)
        end if
    end function peek

    function pop(self) result(pair)
        implicit none
        class(t_stack), intent(inout) :: self
        type(t_elem) :: pair

        if (self%head >= 1) then
            pair = self%peek()
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

end module pair_stack

module my_mod
    implicit none

contains

    function step(levels) result(flashes)
        integer, intent(inout) :: levels(:)
        integer :: flashes
        flashes = 0

        ! (1)
        levels = levels + 1

        ! (2)


        ! (3)


    end function step

end module my_mod

program aoc21_11a
    use my_mod
    implicit none

    integer, parameter :: FID = 9
    integer :: IERR = 0
    integer :: ARG_LEN ! how long the arg (path is)
    character(200) :: TMP
    character(:), allocatable :: PATH
    integer :: LENGTH, I

    integer :: num_lines = -1
    integer, allocatable :: levels(:,:)


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

    ! find out line length
    rewind(FID)
    read(FID, "(A)") TMP
    LENGTH = len_trim(TMP)

    ! read into array
    rewind(FID)
    allocate(integer :: levels(LENGTH, num_lines))
    write(TMP, *) LENGTH
    read(FID, "("//trim(adjustl(TMP))//"(I1))") levels

    close(FID)

    write(*, "(10(I2))") levels

end program aoc21_11a
