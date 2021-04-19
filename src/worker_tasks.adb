with Text_IO; use Text_IO;
with Ada.Strings.Bounded;
with GNATCOLL.Mmap; use GNATCOLL.Mmap;
with Scanner_Regex; use Scanner_Regex;
with Ada.Strings; use Ada.Strings;
package body Worker_Tasks is
   Largest_Match : constant Integer := 108;
   
   package B_Str is new
     Ada.Strings.Bounded.Generic_Bounded_Length (Max => Largest_Match);
   
   function File_Extension (File_Name : String) return String is
   begin
      for C in reverse File_Name'Range loop
         if File_Name (C) = '.' then
            return File_Name (C .. File_Name'Last);
         end if;
      end loop;
      return "";
   end File_Extension;
   
   function Truncate_Long_Long (L : Long_Long_Integer;
                                M : Integer := Integer'Last) return Integer is
   begin
      if Long_Long_Integer (M) < L then
         return M;
      else
         return Integer (L);
      end if;
   end Truncate_Long_Long;
   
   procedure Search_File (File_Name : String;
                          CAccess   : Common_Access;
                          Scanner   : Scanner_Class;
                          Opts      : Options_Type) is
      File             : Mapped_File;
      Reg              : Mapped_Region;
      Str              : Long.Str_Access;
      
      L                : Long_Long_Integer;
      M                : constant Integer := 1024*256;
      Size_To_Read     : Integer;
      Total_Bytes_Read : Long_Long_Integer := 0;
      Last_Read_Ending : B_Str.Bounded_String := B_Str.To_Bounded_String ("");
   begin
      File := Open_Read (Filename              => File_Name,
                         Use_Mmap_If_Available => True);
      Reg := Read (File);
      
      Str := Long.Data (Reg);
      
      L := Long.Last (Reg);
      
      if L > 0 then
         while Total_Bytes_Read /= L loop
            Size_To_Read := Truncate_Long_Long (L => L-Total_Bytes_Read,
                                                M => M);
            declare
               S : String (1..Size_To_Read);
            begin
            
               for V in Total_Bytes_Read + 1 .. Total_Bytes_Read + Long_Long_Integer(Size_To_Read) loop
                  if Str.all (V) = Character'Val (0) then
                     S (Truncate_Long_Long(V-Total_Bytes_Read)) := '0';
                  else
                     S (Truncate_Long_Long(V-Total_Bytes_Read)) := Str.all (V);
                  end if;
               end loop;
            
               Scan (Scanner, B_Str.To_String (Last_Read_Ending) & S, Opts, File_Name, CAccess);
               
               Total_Bytes_Read := Total_Bytes_Read + Long_Long_Integer (Size_To_Read);
                  
               Last_Read_Ending := B_Str.To_Bounded_String (Source => S,
                                                            Drop   => Left);
            exception
               when others =>
                  null;
            end;
            
         end loop;
         
         CAccess.all.Add_File_Result(FL => Total_Bytes_Read);
      end if;
      
      Free (Reg);
      Close (File);
   exception
      when others => Put_Line ("Failed to process file: " & File_Name);
   end;

   task body Worker_Task is
      Q       : Queue_Access;
      C       : Common_Access;
      Path    : Unbounded_String := End_String;
      Opts    : Options_Type;
      Scanner : Scanner_Class;
      
   begin
      Initialize_Scanner(Scanner);
      
      -- Accept queue access location and program options
      accept Receive_Access(QAccess      : Queue_Access;
                            CAccess      : Common_Access;
                            Prog_Options : Options_Type) do
         Q    := QAccess;
         C    := CAccess;
         Opts := Prog_Options;
      end Receive_Access;
      
      loop
         -- Take a path from the queue. This call blocks.
         Q.all.Dequeue (Path);
         
         if Opts.Verbose then
            Put_Line ("Removed from queue: " & To_String(Path));
         end if;
         if Path = End_String then
            if Opts.Verbose then
               Put_Line ("End string found, task exiting!");
            end if;
            exit;
         else
            Search_File(File_Name => To_String(Path),
                        CAccess   => C,
                        Scanner   => Scanner,
                        Opts      => Opts);
         end if;
      end loop;
   exception
      when others =>
         Put_Line ("Unhandled Exception Occured");
      
   end Worker_Task;

end Worker_Tasks;
