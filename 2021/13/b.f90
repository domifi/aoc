module mod
    implicit none

contains

end module mod

program aoc21_13b
    use mod
    implicit none

    integer, parameter :: FID = 9
    integer :: IERR = 0
    integer :: ARG_LEN ! how long the arg (path is)
    character(100) :: TMP ! somewhere to read the lines to
    character(:), allocatable :: PATH
    integer :: I, J, SEAM, END
    logical, allocatable :: TMP_PAPER(:,:)

    integer :: num_paper_lines = 0
    integer :: num_fold_instructions = -1
    logical, allocatable :: paper(:,:)
    integer, allocatable :: paper_lines(:,:)
    integer, allocatable :: fold_instructions(:,:) ! index, axis (121 = y)


    ! check number of cli arguments and get the argument:
    if (command_argument_count() /= 1) THEN
        call get_command_argument(number=0, value=TMP)
        print *, "Usage: "//trim(adjustl(TMP))//" input_file"
        stop
    else
        call get_command_argument(number=1, length=ARG_LEN)
        allocate(character(ARG_LEN) :: PATH)
        call get_command_argument(number=1, value=PATH)
    end if

    open(FID, file=PATH)

    ! find out number of lines:
    do while (IERR == 0)
        read(FID, "(A)", iostat=IERR) TMP
        if (index(TMP, ",") /= 0) then
            num_paper_lines = num_paper_lines + 1
        else if (index(TMP, "fold along") /= 0) then
            num_fold_instructions = num_fold_instructions + 1
        end if
    end do

    ! read dot coordinates
    rewind(FID)
    allocate(integer :: paper_lines(2,num_paper_lines))
    read(FID, *) paper_lines
    paper_lines = paper_lines + 1 ! 1-indexed arrays ftw!

    ! read fold instructions
    allocate(integer :: fold_instructions(2,num_fold_instructions))
    do I = 1, num_fold_instructions
        read(FID, *) TMP, TMP, TMP
        read(TMP(index(TMP, "=")+1:), *) fold_instructions(1,I)
        fold_instructions(2,I) = iachar(TMP(1:1))
    end do
    fold_instructions(1,:) = fold_instructions(1,:) + 1

    close(FID)

    ! fill paper with dots
    allocate(logical :: paper(maxval(paper_lines(1,:)), maxval(paper_lines(2,:))))
    paper = .false.
    do I = 1, num_paper_lines
        paper(paper_lines(1,I), paper_lines(2,I)) = .true.
    end do

    ! fold
    do I = 1, num_fold_instructions
        SEAM = fold_instructions(1,I)
        if (achar(fold_instructions(2,I)) == 'x') then
            END = size(paper, 1)
            allocate(logical :: TMP_PAPER(SEAM-1, size(paper, 2)))
            TMP_PAPER = paper(:SEAM-1,:)
            TMP_PAPER(2*SEAM-END:SEAM-1,:) = paper(2*SEAM-END:SEAM-1,:) .or. paper(END:SEAM+1:-1,:)
        else ! y
            END = size(paper, 2)
            allocate(logical :: TMP_PAPER(size(paper, 1), SEAM-1))
            TMP_PAPER = paper(:,:SEAM-1)
            TMP_PAPER(:,2*SEAM-END:SEAM-1) = paper(:,2*SEAM-END:SEAM-1) .or. paper(:,END:SEAM+1:-1)
        end if
        call move_alloc(TMP_PAPER, paper)
    end do

    ! print
    do J = 1, size(paper, 2)
        do I = 1, size(paper, 1)
            if (paper(I,J)) then
                write(*, fmt="(A)", advance="no") "██"
            else
                write(*, fmt="(A)", advance="no") "  "
            end if
        end do
        print *, ''
    end do

end program aoc21_13b
