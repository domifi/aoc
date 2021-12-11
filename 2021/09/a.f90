module mod
    implicit none

contains

    pure function height(x, y, arr) result(b)
    integer, intent(in) :: x, y
    integer, intent(in) :: arr(:,:)
    logical b
    integer :: xa, xb, ya, yb
    if (x < 1) then
        xa = 9
    else if (size(arr,1) < x) then
        xb = 9
    end if
    if (y < 1) then
        ya = 9
    else if (size(arr,2) < y) then
        yb = 9
    end if
    ! todo
end module mod

program aoc21_09a
    use mod
    implicit none

    integer, parameter :: FID = 9
    integer :: IERR = 0
    integer :: ARG_LEN ! how long the arg (path is)
    character(200) :: TMP ! somewhere to read the lines to
    character(:), allocatable :: PATH
    integer :: I, LENGTH

    integer :: num_lines = -1
    integer, allocatable :: map(:,:)


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
    read(FID, *) TMP
    LENGTH = len_trim(TMP)

    ! read input
    rewind(FID)
    allocate(integer :: map(LENGTH, num_lines))
    write(TMP, *) LENGTH
    do I = 1, num_lines
        read(FID, "("//trim(adjustl(TMP))//"(I1))") map(:,I)
    end do

    close(FID)

    ! do stuff
    print *, map(11,5)


end program aoc21_09a
