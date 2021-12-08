module mod
    implicit none

    private
    public num_nums

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
    end function

end module mod

program aoc21_04a
    use mod
    implicit none

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

    ! find out length of sequence and read it
    rewind(FID)
    read(FID, "(A)") TMP
    allocate(integer :: sequence(num_nums(trim(TMP))))
    read(TMP, *) sequence


    close(FID)

end program aoc21_04a
