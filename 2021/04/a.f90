program aoc21_04a
    implicit none

    use delim

    integer :: FID = 9
    integer :: IERR = 0
    integer :: ARG_LEN ! how long the arg (path is)
    character*255 :: TMP ! somewhere to read the lines to
    !integer :: I
    character(:), allocatable :: PATH

    integer :: num_lines = -1
    integer, allocatable :: sequence(:)

    ! check number of cli arguments and get the argument:
    if (command_argument_count() /= 1) THEN
        print *, "Usage: executable path"
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

    ! find out number of digits per line
    rewind(FID)
    read(FID, "") sequence
    print *, sequence



    close(FID)


end program aoc21_04a
