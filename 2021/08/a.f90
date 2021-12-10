module mod
    implicit none

contains
    elemental function matches(n) result(b)
        implicit none
        integer, intent(in) :: n
        logical :: b
        b = n==2 .or. n==3 .or. n==4 .or. n==7
    end function matches

end module mod

program aoc21_08a
    use mod
    implicit none

    integer, parameter :: FID = 9
    integer :: IERR = 0
    integer :: ARG_LEN ! how long the arg (path is)
    character(200) :: TMP ! somewhere to read the lines to
    character(:), allocatable :: PATH
    integer :: I

    integer :: num_lines = -1
    character(7), allocatable :: output_values(:,:)


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

    ! read back parts
    rewind(FID)
    allocate(character*7 :: output_values(4, num_lines))
    do I = 1, num_lines
        read(FID, "(A)") TMP
        read(TMP(62:), *) output_values(:,I)
    end do

    close(FID)

    ! do stuff
    print *, count(matches(len_trim(adjustl(pack(output_values, .true.)))))


end program aoc21_08a
