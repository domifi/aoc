program aoc21_03a
    implicit none

    integer :: FID = 9
    integer :: IERR = 0
    integer :: ARG_LEN ! how long the arg (path is)
    character*256 :: TMP ! somewhere to read the lines to
    Integer :: TMP_I ! somewhere to read the lines to
    integer :: I
    character(:), allocatable :: PATH

    integer :: num_lines = -1
    integer :: digits
    integer :: gamma
    integer :: epsilon
    integer, allocatable :: data(:,:)
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

    open(FID, file=PATH)

    ! find out number of lines:
    do while (IERR == 0)
        num_lines = num_lines + 1
        read(FID, *, iostat=IERR) TMP
    end do

    ! find out number of digits per line
    rewind(FID)
    read(FID, *) TMP
    digits = len_trim(TMP)

    !actually read the file:
    allocate(counter(digits))
    allocate(data(digits,num_lines))
    rewind(FID)
    write(TMP, *) digits
    TMP = "("//trim(adjustl(TMP))//"(I1))"
    do I = 1, num_lines
        read(FID, TMP) data(:,I)
    end do

    close(FID)

    ! count digits
    gamma = 0
    epsilon = 0
    counter = sum(transpose(data), dim=1)
    TMP_I = num_lines / 2
    do I = 1, TMP_I
        if (counter(I) >= TMP_I) then
            gamma = gamma + 2 ** (digits - I)
        else
            epsilon = epsilon + 2 ** (digits - I)
        end if
    end do

    print *, gamma * epsilon

end program aoc21_03a
