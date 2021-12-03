program aoc21_03b
    implicit none

    ! helper variables
    integer :: FID = 9
    integer :: IERR = 0
    integer :: ARG_LEN ! how long the arg (path is)
    character*256 :: TMP_STR ! temporary string
    integer :: BITMASK
    integer, allocatable :: INTERMEDIATE(:) ! somewhere to read the lines to
    integer, allocatable :: TMP_ARR(:) ! temporary array
    integer :: I
    character*256 :: FORMAT
    character(:), allocatable :: PATH

    ! data varaibles
    integer :: num_lines = -1
    integer :: digits
    integer :: o2_generator
    integer :: co2_scrubber
    integer, allocatable :: data(:)
    integer, allocatable :: counter(:)

    ! check number of cli arguments and get the argument:
    if (command_argument_count() /= 1) THEN
        print *, "Usage: executable path"
        stop
    else
        call get_command_argument(number=1, length=ARG_LEN)
        allocate(character(ARG_LEN) :: PATH)
        call get_command_argument(number=1, value=PATH)
    end if

    open(FID, file=PATH, status="old", action="read")

    ! find out number of lines:
    do while (IERR == 0)
        num_lines = num_lines + 1
        read(FID, *, iostat=IERR) TMP_STR
    end do

    ! find out number of digits per line
    rewind(FID)
    read(FID, *) TMP_STR
    digits = len_trim(TMP_STR)

    !actually read the file:
    allocate(counter(digits))
    allocate(data(num_lines))
    rewind(FID)
    write(TMP_STR, *) digits
    FORMAT = "(B"//trim(adjustl(TMP_STR))//")"
    do I = 1, num_lines
        read(FID, FORMAT) data(I)
    end do

    close(FID)

    ! filter numbers
    o2_generator = 0
    INTERMEDIATE = data
    do I=1, digits
        BITMASK = 2**(digits - I)

        TMP_ARR = pack(INTERMEDIATE, iand(INTERMEDIATE, BITMASK) /= 0)
        if (size(TMP_ARR) >= (size(INTERMEDIATE) / 2.0)) then
            o2_generator = ior(o2_generator, BITMASK)
            INTERMEDIATE = TMP_ARR
        else
            INTERMEDIATE = pack(INTERMEDIATE, iand(INTERMEDIATE, BITMASK) == 0)
        end if
    end do

    co2_scrubber = 0
    INTERMEDIATE = data

    I = 1
    do while (size(INTERMEDIATE) > 1 .and. I <= digits)
        BITMASK = 2**(digits - I)
        write(*, FORMAT) INTERMEDIATE
        print *, "-----"

        if (size(pack(INTERMEDIATE, iand(INTERMEDIATE, BITMASK) /= 0)) < &
                size(pack(INTERMEDIATE, iand(INTERMEDIATE, BITMASK) == 0))) then
            INTERMEDIATE = pack(INTERMEDIATE, iand(INTERMEDIATE, BITMASK) /= 0)
        else
            INTERMEDIATE = pack(INTERMEDIATE, iand(INTERMEDIATE, BITMASK) == 0)
        end if
        I = I + 1
    end do
    co2_scrubber = INTERMEDIATE(1)

    ! this took way too long
    print *, o2_generator * co2_scrubber

end program aoc21_03b
