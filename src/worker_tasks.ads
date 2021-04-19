with String_Queue;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Options; use Options;
with Common_Data; use Common_Data;

package Worker_Tasks is
   
   type Queue_Access is access all String_Queue.Queue;
   
   End_String : constant Unbounded_String := To_Unbounded_String("\ / : * ? | < >");

   task type Worker_Task is
      
      -- Sends information to task required for execution
      entry Receive_Access(QAccess      : Queue_Access;
                           CAccess      : Common_Access;
                           Prog_Options : Options_Type)
      with Pre => QAccess /= null and CAccess /= null;
   end Worker_Task;
   
   function File_Extension (File_Name : String) return String;
   
   function Truncate_Long_Long (L : Long_Long_Integer;
                           M : Integer := Integer'Last) return Integer
     with Post => (if L > Long_Long_Integer (M) then
                       Truncate_Long_Long'Result = M else
                         Truncate_Long_Long'Result = Integer (L));

end Worker_Tasks;
