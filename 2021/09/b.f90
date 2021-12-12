module mod
    use pair_stack
    implicit none

contains

    pure function get_height(x, y, arr) result(h)
        integer, intent(in) :: arr(:,:)
        integer, intent(in) :: x, y
        integer :: h
        if (x < 1 .or. size(arr,1) < x .or. y < 1 .or. size(arr,2) < y) then
            h = 9
        else
            h = arr(x,y)
        end if
    end function get_height

    pure function is_min(x, y, arr) result(b)
        integer, intent(in) :: x, y
        integer, intent(in) :: arr(:,:)
        logical b
        integer :: xa, xb, ya, yb, xy

        xa = get_height(x-1, y,   arr)
        xb = get_height(x+1, y,   arr)
        ya = get_height(x  , y-1, arr)
        yb = get_height(x  , y+1, arr)
        xy = arr(x,y)

        b = xa > xy .and. xb > xy .and. ya > xy .and. yb > xy
    end function is_min

    function basin_size(x, y, arr) result(n)
        implicit none
        integer, intent(in) :: x, y
        integer, intent(in) :: arr(:,:)
        integer :: n
        type(t_stack) :: stack
        type(t_elem) :: current
        integer :: current_height, next_height, cx, cy
        logical, allocatable :: visited(:,:)

        allocate(logical :: visited(size(arr, 1), size(arr, 2)))
        visited = .false.

        call stack%push(x, y)
        do while (stack%stack_size() >= 1)
            current = stack%pop()
            cx = current%x
            cy = current%y
            if (.not. visited(cx, cy)) then
                current_height = arr(current%x, current%y)
                visited(cx, cy) = .true.

                ! 1
                next_height = get_height(cx-1, cy, arr)
                if (next_height > current_height .and. next_height /= 9) then
                    call stack%push(cx-1, cy)
                end if
                !2
                next_height = get_height(cx+1, cy, arr)
                if (next_height > current_height .and. next_height /= 9) then
                    call stack%push(cx+1, cy)
                end if
                !3
                next_height = get_height(cx, cy-1, arr)
                if (next_height > current_height .and. next_height /= 9) then
                    call stack%push(cx, cy-1)
                end if
                !4
                next_height = get_height(cx, cy+1, arr)
                if (next_height > current_height .and. next_height /= 9) then
                    call stack%push(cx, cy+1)
                end if
            end if
        end do
        n = count(visited)
    end function basin_size
end module mod

program aoc21_09b
    use mod
    implicit none

    integer, parameter :: FID = 9
    integer :: IERR = 0
    integer :: ARG_LEN ! how long the arg (path is)
    character(200) :: TMP ! somewhere to read the lines to
    character(:), allocatable :: PATH
    integer :: I, J, LENGTH, RESULT
    integer, allocatable :: TMP_ARR(:)


    integer :: num_lines = -1
    integer, allocatable :: map(:,:), basins(:,:)
    logical, allocatable :: min_mask(:,:)


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
    allocate(integer :: basins(LENGTH, num_lines))
    allocate(logical :: min_mask(LENGTH, num_lines))
    write(TMP, *) LENGTH
    do I = 1, num_lines
        read(FID, "("//trim(adjustl(TMP))//"(I1))") map(:,I)
    end do

    close(FID)

    ! make min_mask
    do I = 1, size(min_mask, 1)
        do J = 1, size(min_mask, 2)
            min_mask(I,J) = is_min(I,J,map)
        end do
    end do

    ! explore basins
    do I = 1, size(min_mask, 1)
        do J = 1, size(min_mask, 2)
            if (min_mask(I,J)) then
                basins(I,J) = basin_size(I, J, map)
            end if
        end do
    end do

    ! maximum
    TMP_ARR = maxloc(basins)
    RESULT = basins(TMP_ARR(1), TMP_ARR(2))
    basins(TMP_ARR(1), TMP_ARR(2)) = -1
    ! 2nd maximum
    TMP_ARR = maxloc(basins)
    RESULT = RESULT * basins(TMP_ARR(1), TMP_ARR(2))
    basins(TMP_ARR(1), TMP_ARR(2)) = -1
    ! 3rd maximum
    TMP_ARR = maxloc(basins)
    RESULT =  RESULT * basins(TMP_ARR(1), TMP_ARR(2))

    print *, RESULT

end program aoc21_09b
