program aoc21_01a
    implicit none

    integer :: FID = 9
    integer :: IERR = 0
    integer :: ARG_LEN ! how long the arg (path is)
    integer :: TMP ! somewhere to read the lines to
    integer :: I
    integer :: PREV
    character(:), allocatable :: PATH

    integer :: num_lines = -1
    integer :: incr_counter
    integer, allocatable :: data(:)

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

    !actually read the file:
    allocate(data(num_lines))
    rewind(FID)
    do I = 1, num_lines
        read(FID, *) data(I)
    end do

    close(FID)

    ! count jumps
    incr_counter = 0
    PREV = data(1)
    do I = 2, num_lines
        if (data(I) > PREV) then
            incr_counter = incr_counter + 1
        end if
        PREV = data(I)
    end do

    print *, incr_counter

end program aoc21_01a
