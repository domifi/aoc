module mod
    implicit none

contains
    ! num_nums counts the elements in a comma separated string. "1,23" -> 2
    pure function num_nums(str) result(n)
        implicit none
        character(*), intent(in) :: str
        integer :: i
        integer :: n

        n = 1
        do i = 1, len(str)
            if (str(i:i) == ',') then
                n = n + 1
            end if
        end do

        if (len(str) == 0) then
            n = 0
        end if
    end function num_nums

    pure function bingo(board) result(won)
        implicit none
        logical, intent(in) :: board(:,:)
        logical :: won
        won = any(all(board, 1)) .or. any(all(board, 2))
    end function bingo

    subroutine read_boards(fid, num_boards, boards)
        implicit none
        integer, intent(in) :: fid
        integer, intent(in) :: num_boards
        integer, allocatable, intent(out) :: boards(:, :, :)
        allocate(integer :: boards(5, 5, num_boards))
        read(fid, *) boards
    end subroutine read_boards

    subroutine mark(board, n, marks)
        implicit none
        integer, intent(in) :: board(:,:)
        integer, intent(in) :: n
        logical, intent(out) :: marks(:,:)
        integer :: i(rank(board))
        i = findloc(board, n)
        if (.not. all(i == 0)) then
            marks(i(1), i(2)) = .true.
        end if
    end subroutine mark

end module mod

program aoc21_04b
    use mod
    implicit none

    integer, parameter :: FID = 9
    integer :: IERR = 0
    integer :: ARG_LEN ! how long the arg (path is)
    character*1023 :: TMP ! somewhere to read the lines to
    integer :: I, J, SCORE
    character(:), allocatable :: PATH

    integer :: num_lines = -1
    integer, allocatable :: sequence(:)
    integer, allocatable :: boards(:,:,:)
    logical, allocatable :: marks(:,:,:)
    logical, allocatable :: done(:)

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

    ! find out length of sequence and read it
    rewind(FID)
    read(FID, "(A)") TMP
    allocate(integer :: sequence(num_nums(trim(TMP))))
    read(TMP, *) sequence

    call read_boards(FID, (num_lines - 1) / 5, boards)

    close(FID)

    ! mark
    allocate(logical :: marks(size(boards, 1), size(boards, 2), size(boards, 3)))
    allocate(logical :: done(size(boards, 3)))
    marks = .false.
    done = .false.
    do I = 1, size(sequence)
        do J = 1, size(boards, 3)
            call mark(boards(:,:,J), sequence(i), marks(:,:,J))
            if (.not. done(J)) then
                if (bingo(marks(:,:,J))) then
                    done(J) = .true.
                    SCORE = sum(boards(:,:,J), .not. marks(:,:,J)) * sequence(I)
                end if
            end if
        end do
    end do

    print *, SCORE
end program aoc21_04b
