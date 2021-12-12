module pair_stack
    implicit none
    private

    type, public :: t_elem
        sequence
        integer :: x,y
    end type

    type, public :: t_stack
        integer, private :: head
        type(t_elem), private :: arr(1000)
    contains
        procedure, public :: push,pop,peek,stack_size
    end type


contains
    subroutine push(self, x,y)
        implicit none
        class(t_stack), intent(inout) :: self
        integer, intent(in) :: x,y
        type(t_elem) :: pair

        pair = t_elem(x,y)
        self%head = self%head + 1
        self%arr(self%head) = pair
    end subroutine push

    function peek(self) result(pair)
        implicit none
        class(t_stack), intent(in) :: self
        type(t_elem) :: pair
        if (self%head >= 1) then
            pair = self%arr(self%head)
        else
            !write(*,*) "Tried to access empty stack. Exiting"
            call exit(1)
        end if
    end function peek

    function pop(self) result(pair)
        implicit none
        class(t_stack), intent(inout) :: self
        type(t_elem) :: pair

        if (self%head >= 1) then
            pair = self%peek()
            self%head = self%head - 1
        else
            !write(*,*) "Tried to access full stack. Exiting"
            call exit(1)
        end if
    end function pop

    pure function stack_size(self) result(n)
        implicit none
        class(t_stack), intent(in) :: self
        integer :: n
        n = self%head
    end function stack_size

end module pair_stack
