Module SLL 
   type node
      integer:: data
      type(node),pointer::next   
   end type node 

   type list 
      type(node),pointer::head=>null() 
      type(node),pointer::tail=>null() 
      contains 
         procedure::append 
         procedure::display 
         procedure::getLen 
         procedure::insert  
         procedure::delete 
         procedure::kill 
         procedure::reverse 
         procedure::get_nthItem 
   end type list  

contains 
   function new(data)result(new_node)
      implicit none 
      integer::data 
      type(node),pointer::new_node 

      allocate(new_node)
      new_node%data=data 
      new_node%next=>null() 
   end function new 

   subroutine append(self,data)
      implicit none 
      class(list)::self 
      integer:: data 
      type(node),pointer::new_node 

      new_node=>new(data) 
      if(.not.associated(self%head))then 
         self%head=>new_node 
         self%tail=>new_node 
         new_node=>null() 
      else
         self%tail%next=>new_node 
         self%tail=>new_node
         new_node=>null() 
      endif 
   end subroutine 

   subroutine insert(self,pos,data)
      implicit none 
      class(list)::self 
      integer::pos 
      integer:: data 
      type(node),pointer::new_node,iterator,right 
      integer::front,last,ipos  

      front=1
      last=self%getLen()+1 
      
      new_node=>new(data) 
      if(pos==front)then 
         new_node%next=>self%head 
         self%head=>new_node 
      elseif (pos>=last .or. pos==-1)then
         self%tail%next=>new_node 
         self%tail=>new_node
         new_node=>null() 
      else 
         iterator=>self%head 
         ipos=0
         do while(associated(iterator))
            ipos=ipos+1 
            if(ipos==pos)then 
               right=>iterator%next  
               new_node%next=>right 
               iterator%next=>new_node 
            else  
               iterator=>iterator%next
            endif  
         enddo 
      endif 

   end subroutine 

   function  getLen(self)result(len)
      implicit none 
      class(list)::self 
      integer:: len 
      type(node),pointer::iterator 

      iterator=>self%head 
      
      len=0
      do while(associated(iterator))
         len=len+1 
         iterator=>iterator%next
      enddo 
   end function getLen 

   subroutine display(self)
      implicit none 
      class(list)::self 
      integer:: data 
      type(node),pointer::new_node 

      new_node=>self%head 
      
      write(*,'(A)',advance='no')'List: '
      do while(associated(new_node))
         write(*,'(I3)',advance='no')(new_node%data)
         new_node=>new_node%next
      enddo 
      write(*,'(I3)',advance='yes')
   end subroutine display 

   subroutine delete(self,pos)
      implicit none 
      class(list)::self 
      integer::pos 
      integer:: data 
      type(node),pointer::temp,current,previous    
      integer::front,last,ipos  

      front=1
      
      if(pos==front)then
         temp=>self%head 
         self%head=>self%head%next 
         deallocate(temp)

      elseif (pos==-1)then
         current=>self%head 
         do while(associated(current%next))
            previous=>current 
            current=>current%next 
         enddo 
         self%tail=>previous 
         self%tail%next=>null() 
         deallocate(current)

      else 

         ipos=0
         current=>self%head
         do ipos=1,pos-1  
            previous=>current 
            current=>current%next 
         enddo 
         previous%next=>current%next 
         deallocate(current)

      endif 

   end subroutine 

   subroutine kill(self)
      implicit none 
      class(list)::self 
      integer::pos 
      integer:: data 
      type(node),pointer::temp  

     
      do while(associated(self%head))
         temp=>self%head 
         self%head=>self%head%next 
         deallocate(temp)
      enddo 
   end subroutine 


   subroutine reverse(self)
      implicit none 
      class(list)::self 
      type(node),pointer::current,previous,next     

      previous=>null()
      current=>self%head 
      next=>null() 

      do while(associated(current))
         next=>current%next 
         current%next=>previous
         previous=>current 
         current=>next 
      enddo 
      self%head=>previous 

   end subroutine 

   function get_nthItem(self,pos)result(data)
      implicit none 
      class(list)::self 
      integer::pos 
      integer:: data 
      type(node),pointer::iterator    
      integer::ipos 
      logical::isFound 

      ipos=0 
      iterator=>self%head 
      do while(associated(iterator))
         ipos=ipos+1 
         if(ipos==pos)then
            isFound=.True. 
            data=iterator%data 
            return 
         else 
            iterator=>iterator%next 
         endif 
      enddo 

      if(.not.isFound)then 
         write(*,'(A)')'Item not found'
         stop 
      endif 
      

   end function  
End Module SLL 

program main 
   use SLL 
   type(list)::mylist 

   call mylist%append(5)
   call mylist%append(6)
   call mylist%append(7)
   call myList%insert(1,4)
   call myList%insert(1,3)
   call myList%insert(7,8)
   call myList%insert(2,-1)
   call myList%delete(1)
   call myList%delete(1)
   call myList%delete(-1)
   call myList%delete(3)
   call mylist%display() 
   call mylist%reverse() 
   call mylist%display() 
   call mylist%kill()
   print*,('Killed')
   call mylist%display() 
   
   print*,(myList%get_nthItem(1))
   print*,(myList%getLen())

end program main 
