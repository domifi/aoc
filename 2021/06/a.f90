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

program aoc21_06a
    use mod
    implicit none

    integer, parameter :: FID = 9
    integer :: ARG_LEN ! how long the arg (path is)
    character*1000 :: TMP ! somewhere to read the lines to
    character(:), allocatable :: PATH
    integer :: I, J, GROWTH

    integer, pointer :: fish(:)
    integer, pointer :: fish_tmp(:)


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
    allocate(integer :: fish(num_nums(trim(TMP))))
    read(TMP, *) fish

    close(FID)

    do I = 1, 80
        fish = fish - 1
        GROWTH = count(fish == -1)
        allocate(integer :: fish_tmp(size(fish) + GROWTH))
        fish_tmp = fish
        fish_tmp(size(fish)+1:) = 8
        do J = 0, size(fish)
            if (fish_tmp(J) == -1) then
                fish_tmp(J) = 6
            end if
        end do
        deallocate(fish)
        allocate(integer :: fish(size(fish_tmp)))
        fish = fish_tmp
        deallocate(fish_tmp)
    end do

    print *, size(fish)

end program aoc21_06a
