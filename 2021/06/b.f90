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
end module mod

program aoc21_06b
    use mod
    implicit none

    integer, parameter :: FID = 9
    integer :: ARG_LEN ! how long the arg (path is)
    character*1000 :: TMP ! somewhere to read the lines to
    character(:), allocatable :: PATH
    integer :: I

    integer, allocatable :: sequence(:)
    integer*8 :: fish(0:8)

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

    ! find out length of sequence and read it
    read(FID, "(A)") TMP
    allocate(integer :: sequence(num_nums(trim(TMP))))
    read(TMP, *) sequence

    close(FID)

    ! init fish
    fish = 0
    do I = 1, size(sequence)
        fish(sequence(I)) = fish(sequence(I)) + 1
    end do
    deallocate(sequence)

    ! let days pass
    do I = 1, 256
        fish = cshift(fish, 1)
        fish(6) = fish(6) + fish(8)
    end do

    print *, sum(fish)

end program aoc21_06b
