with Ada.Containers.Vectors;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Common_Data is
   
   type File_Found_Type is record
      File_Name    : Unbounded_String;
      Found_String : Unbounded_String;
      Name         : Unbounded_String;
   end record;
   
   package File_Found_Vectors is new Ada.Containers.Vectors
     (Index_Type => Natural,
      Element_Type => File_Found_Type);
   use File_Found_Vectors;
   
   protected type Common_Data_Type is
      procedure Add_File_Result (FL : Long_Long_Integer);
      -- When a file has finished processing, this is called to add metadata to for console output.
          
      procedure Add_Scan_Result (File_Name    : String;
                                 Found_String : String;
                                 Found_Type   : String);
      -- When a match has been found, the filename, the type of string found, and the string itself are added for output.
      
      procedure Print_Results;
      -- Prints final results to console
      
      procedure Print_To_File (File_Name : String);
      -- Prints final results to a file
      
      procedure Print_Current;
      -- Prints the current metadata to track progress in console (Printed once per second and at program finish)
      
   private
      File_Count      : Integer := 0;
      Total_File_Size : Long_Long_Integer := 0;
      Found_Strings   : File_Found_Vectors.Vector;
   end Common_Data_Type;
   
   type Common_Access is access Common_Data_Type;
   
   task type Status_Task_Type is
      entry Receive_Access (Data      : Common_Access);
      -- Receives an access type to the common data protected object
      
      entry Print_And_Exit (File_Name : String);
      -- When the program is finished, call the final print command on the data and exit the task
      
      entry Early_Exit;
      -- Exit the task early (will happen if requirements are not satisfied to begin running the program
      
   end Status_Task_Type;

   function Int_Image (I : Long_Long_Integer) return String;
   -- Similar to 'Image except it places commas in the integer where appropriate.
end Common_Data;
