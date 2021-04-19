with Ada.Text_IO; use Ada.Text_IO;


package body Common_Data is
   
   function Int_Image (I : Long_Long_Integer) return String is
      Default_Image : constant String := Long_Long_Integer'Image (I);
      Num_Digits    : constant Natural := (Default_Image'Length - 1);
      Commas        : constant Natural := (Num_Digits - 1) / 3; -- (Num_Digits + (2)) / 3;
      Total_Length  : constant Natural := Num_Digits + Commas + 1;
      
      New_String : String (Default_Image'First .. Default_Image'First + Total_Length - 1)
        := (others => ',');
      Offset     : Integer := 0;
      type Wrap_Type is mod 3;
      Iterations : Wrap_Type := 2 - Wrap_Type (Num_Digits mod 3);
   begin
      for Current in Default_Image'Range loop
         New_String (Current + Offset) := Default_Image (Current);
         if Iterations = 2 and Current /= Default_Image'First then
            Offset := Offset + 1;
         end if;
         Iterations := Wrap_Type'Succ (Iterations);
      end loop;
      return New_String;
   end;
   -- Returns an image of the input integer with added commas

   protected body Common_Data_Type is
      procedure Add_File_Result (FL : Long_Long_Integer) is
      begin
         Total_File_Size := Total_File_Size + FL;
         File_Count := File_Count + 1;
      end;
      
      procedure Add_Scan_Result (File_Name    : String;
                                 Found_String : String;
                                 Found_Type   : String) is
      begin
         Found_Strings.Append(New_Item => (To_Unbounded_String (File_Name),
                                           To_Unbounded_String (Found_String),
                                           To_Unbounded_String (Found_Type)));
      end;
      
      procedure Print_Results is
      begin
         Put_Line ("# Files: " & File_Count'Image & ", Total Size: " & Int_Image (Total_File_Size));
         if Found_Strings.Last = No_Element then
            Put_Line ("No Signatures Found");
         else
            Put_Line ("Signatures Found");
            for I in Natural range Found_Strings.First_Index .. Found_Strings.Last_Index loop
               Put_Line ("File: " & To_String(Found_Strings.Element(Index => I).File_Name)
                         & " Found: " & To_String(Found_Strings.Element(Index => I).Found_String)
                         & " Type: " & To_String(Found_Strings.Element(Index => I).Name));
            end loop;
         end if;
         
      end;
      
      procedure Print_To_File (File_Name : String) is
         F : File_Type;
      begin
         Put_Line ("Printing the results to " & File_Name);
         if Found_Strings.Last /= No_Element then
            Create (File => F,
                    Mode => Out_File,
                    Name => File_Name);
            Put_Line (F, "name,found,type");
            for I in Natural range Found_Strings.First_Index .. Found_Strings.Last_Index loop
               Put_Line (F, To_String(Found_Strings.Element(Index => I).File_Name)
                         & " , " & To_String(Found_Strings.Element(Index => I).Found_String)
                         & " , " & To_String(Found_Strings.Element(Index => I).Name));
            end loop;
            Close (File => F);
         end if;
         
      end;
      
      procedure Print_Current is
      begin
         Put_Line ("Files Read: " & Int_Image (Long_Long_Integer (File_Count)) & " - Bytes Read: " & Int_Image (Total_File_Size));
      end;
      
   end Common_Data_Type;
   
   task body Status_Task_Type is
      Local_Data : Common_Access;
      End_Task   : Boolean := False;
   begin
      accept Receive_Access (Data : Common_Access) do
         Local_Data := Data;
      end;
      
      while not End_Task loop
         select
            accept Print_And_Exit (File_Name : String) do
               if File_Name = "" then
                  Local_Data.all.Print_Results;
               else
                  Local_Data.all.Print_To_File(File_Name => File_Name);
               end if;
               End_Task := True;
            end;
         or
            accept Early_Exit do
               End_Task := True;
            end;
         or
            delay 1.0;
            Local_Data.all.Print_Current;
         end select;
      end loop;
   end Status_Task_Type;

end Common_Data;
