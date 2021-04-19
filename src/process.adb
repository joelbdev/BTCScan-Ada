with Ada.Directories; use Ada.Directories;
with Ada.Text_IO; use Ada.Text_IO;
with String_Queue;
with Worker_Tasks; use Worker_Tasks;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers; use Ada.Containers;

package body Process is
         
   procedure Process_Main (Input_Path   : String;
                           Prog_Options : Options_Type;
                           Tasks        : Natural;
                           CA           : Common_Access) 
   is
      Path_Queue        : constant Queue_Access  := new String_Queue.Queue;
      Directories_Queue : constant Queue_Access  := new String_Queue.Queue;
      Tasks_Array       : Tasks_Array_Type (1..Tasks);      
   begin
      -- Give the tasks access to Path_Queue
      for I in 1..Tasks loop
         Tasks_Array(I).Receive_Access (QAccess      => Path_Queue,
                                        CAccess      => CA,
                                        Prog_Options => Prog_Options);
         if Prog_Options.Verbose then
            Put_Line("Started Task " & I'Image);
         end if;
      end loop;
      
      -- Check if path provided exists, if it is a file, add it to the path queue
      -- If it is a directory, add it to the directories queue
      if Ada.Directories.Exists (Name => Input_Path) then
         declare
            Input_File_Kind : File_Kind;
         begin
            Input_File_Kind := Kind (Name => Input_Path);
            if Input_File_Kind = Directory then
               Directories_Queue.all.Enqueue (To_Unbounded_String(Input_Path));
            elsif Input_File_Kind = Ordinary_File then
               Path_Queue.all.Enqueue (To_Unbounded_String(Input_Path));
            else
               Put_Line (Input_Path & " is not an ordinary file or directory!");
            end if;
         end;
      else
         Put_Line ("Input directory/file does not exist!");
      end if;
      
      -- Iteratively add all files in the directory to the path queue
      while Directories_Queue.all.Current_Use > 0 loop
         declare
            Current_Path     : Unbounded_String;
            Directory_Search : Search_Type;
            Directory_Entry  : Directory_Entry_Type;
         begin
            Directories_Queue.all.Dequeue (Current_Path);
            if Prog_Options.Verbose then
               Put_Line ("Searching directory: " & To_String (Current_Path));
            end if;
            Start_Search (Directory_Search, To_String (Current_Path), "");
            
            while More_Entries (Directory_Search) loop
               Get_Next_Entry (Directory_Search, Directory_Entry);
               if Simple_Name (Full_Name (Directory_Entry)) = "." or else Simple_Name (Full_Name (Directory_Entry)) = ".." then
                 null;
               elsif Kind(Directory_Entry) = Directory then
                  Directories_Queue.all.Enqueue(To_Unbounded_String(Full_Name(Directory_Entry)));
               elsif Kind(Directory_Entry) = Ordinary_File then
                  Path_Queue.all.Enqueue(To_Unbounded_String(Full_Name(Directory_Entry)));
               else
                  Put_Line(Input_Path & " is not an ordinary file or directory!");
               end if;
            end loop;
            --End_Search(Directory_Search);
         end;
      end loop;
      
      Put_Line ("Recusive walk completed...");
      
      -- Add the ending string to Path_Queue so the tasks can terminate
      for I in 1..Tasks loop
         Path_Queue.all.Enqueue(End_String);
      end loop;
    
   end Process_Main;

end Process;
