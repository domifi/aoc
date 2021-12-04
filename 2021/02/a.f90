program aoc21_02a
    implicit none

    integer :: FID = 9
    integer :: IERR = 0
    integer :: ARG_LEN ! how long the arg (path is)
    character*256 :: TMP ! somewhere to read the lines to
    character*256 :: TMP2 ! somewhere to read the lines to
    character(:), allocatable :: PATH
    integer :: I

    integer :: num_lines = -1

    character, allocatable :: dirs(:)
    integer, allocatable :: distances(:)
    integer :: hor
    integer :: depth

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

    ! just read the instructions
    allocate(dirs(num_lines))
    allocate(distances(num_lines))
    dirs(:) = "x"
    distances(:) = 0
    rewind(FID)
    do I = 1, num_lines
        read(FID, "(A)") TMP
        read(TMP, *) dirs(I)
        read(TMP, *) TMP2
        read(TMP(len_trim(TMP2)+2:), *) distances(I)
    end do

    close(FID)

    ! and now follow them
    hor = 0
    depth = 0
    do I = 1, NUM_LINES
        select case (dirs(I))
        case ("u")
            depth = depth - distances(I)
        case ("d")
            depth = depth + distances(I)
        case ("f")
            hor = hor + distances(I)
        end select
    end do

    print *, hor * depth

end program aoc21_02a
