program aoc21_01b
    implicit none

    integer :: FID = 9
    integer :: IERR = 0
    integer :: ARG_LEN ! how long the arg (path is)
    integer :: TMP ! somewhere to read the lines to
    integer :: I
    integer :: PREV
    integer :: WINDOW_SIZE
    integer :: PREV_WINDOW
    integer :: WINDOW_BOUND
    character(32) :: TMP_ARG
    character(:), allocatable :: PATH

    integer :: num_lines = -1
    integer :: incr_counter
    integer, allocatable :: data(:)

    ! check number of cli arguments and get the argument:
    if (command_argument_count() /= 2) THEN
        print *, "Usage: executable path window_size"
        stop
    else
        call get_command_argument(number=1, length=ARG_LEN)
        allocate(character(ARG_LEN) :: PATH)
        call get_command_argument(number=1, value=PATH)
        call get_command_argument(number=2, value=TMP_ARG)
        read(TMP_ARG, *) WINDOW_SIZE
    end if

    open(FID, file=PATH)

    ! find out number of lines:
    do while (IERR == 0)
        num_lines = num_lines + 1
        read(FID, *, iostat=IERR) TMP
    end do

    if (num_lines < WINDOW_SIZE) then
        print *, "Input is smaller than the window size. Aborting."
        stop
    end if

    !actually read the file:
    allocate(data(num_lines))
    rewind(FID)
    do I = 1, num_lines
        read(FID, *) data(I)
    end do

    close(FID)

    ! count jumps
    incr_counter = 0
    PREV_WINDOW = sum(data(1:WINDOW_SIZE))
    do I = 2, num_lines - WINDOW_SIZE + 1
        WINDOW_BOUND = I + WINDOW_SIZE - 1
        if (sum(data(I:WINDOW_BOUND)) > PREV) then
            incr_counter = incr_counter + 1
        end if
        PREV = sum(data(I:WINDOW_BOUND))
    end do

    print *, incr_counter

end program aoc21_01b
