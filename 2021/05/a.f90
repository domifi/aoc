module mod
    implicit none

contains
    subroutine mark_line(area, line)
        implicit none
        integer, allocatable, intent(inout) :: area(:,:)
        integer, intent(in) :: line(4)
        integer :: start_x, end_x, start_y, end_y

        start_x = min(line(1), line(3)) + 1
        end_x   = max(line(1), line(3)) + 1
        start_y = min(line(2), line(4)) + 1
        end_y   = max(line(2), line(4)) + 1

        if (start_x == end_x .or. start_y == end_y) then
            area(start_x : end_x, start_y:end_y) = 1 + area(start_x : end_x, start_y:end_y)
        end if
    end subroutine mark_line
end module mod

program aoc21_05a
    use mod
    implicit none

    integer, parameter :: FID = 9
    integer :: IERR = 0
    integer :: ARG_LEN ! how long the arg (path is)
    character*255 :: TMP ! somewhere to read the lines to
    character(:), allocatable :: PATH
    integer :: I

    integer :: num_lines = -1
    integer, allocatable :: vent_lines(:,:)
    integer, allocatable :: area(:,:)

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

    ! read vent_lines
    allocate(integer :: vent_lines(4,num_lines))
    rewind(FID)
    do I = 1, num_lines
        read(FID, *) vent_lines(1:2,I), TMP, vent_lines(3:4,I)
    end do

    close(FID)

    ! init area
    allocate(integer :: area(maxval(vent_lines) + 1, maxval(vent_lines) + 1))
    area = 0

    do I = 1, num_lines
        call mark_line(area, vent_lines(:,I))
    end do

    print *, count(area >= 2)

end program aoc21_05a
