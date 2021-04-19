with Parse_Args; use Parse_Args;
with Ada.Text_IO; use Ada.Text_IO;
with Process; use Process;
with Options; use Options;
with Common_Data; use Common_Data;
with System.Multiprocessors;
with Ada.Real_Time; use Ada.Real_Time;

procedure Main is
   AP         : Argument_Parser;
   CA         : constant Common_Access := new Common_Data_Type;
   Start_Time : Time := Ada.Real_Time.Clock;
   End_Time   : Time;
   Diff       : Time_Span;
begin
   AP.Add_Option(O             => Make_Boolean_Option,
                 Name          => "help",
                 Short_Option  => 'h',
                 Usage         => "Prints a help page");

   AP.Add_Option(O             => Make_String_Option,
                 Name          => "input",
                 Short_Option  => 'i',
                 Usage         => "Specifies drive, directory, and/or files to search");

   AP.Add_Option(O             => Make_Boolean_Option,
                 Name          => "quick",
                 Short_Option  => 'q',
                 Usage         => "Quick mode, does not search BIP32 HD wallet keys");

   AP.Add_Option(O             => Make_Boolean_Option,
                 Name          => "unicode",
                 Short_Option  => 'u',
                 Usage         => "Unicode mode, only search for unicoded items");

   AP.Add_Option(O             => Make_Boolean_Option,
                 Name          => "nonunicode",
                 Short_Option  => 'n',
                 Usage         => "Non-unicode mode, only search for non-unicoded items");

   AP.Add_Option(O             => Make_Boolean_Option,
                 Name          => "verbose",
                 Short_Option  => 'v',
                 Usage         => "Print extra information during execution");

   AP.Add_Option(O             => Make_Integer_Option,
                 Name          => "tasks",
                 Short_Option  => 't',
                 Usage         => "How many worker tasks to create. 0 to automatically pick based on CPU.");

   AP.Add_Option(O             => Make_String_Option,
                 Name          => "outfile",
                 Short_Option  => 'o',
                 Usage         => "Output to outfile.csv");

   AP.Parse_Command_Line;

   if AP.Parse_Success and then AP.Boolean_Value(Name => "help") then
      AP.Usage;

   elsif AP.Parse_Success then
      declare
         Input_Path    : constant String       := AP.String_Value (Name => "input");
         Output_String : constant String       := AP.String_Value (Name => "outfile");
         Prog_Options  : constant Options_Type := (AP.Boolean_Value (Name => "quick"),
                                                   AP.Boolean_Value (Name => "unicode"),
                                                   AP.Boolean_Value (Name => "nonunicode"),
                                                   AP.Boolean_Value (Name => "verbose"));
         Tasks         : Natural      :=  8;
         Status_Task   : Status_Task_Type;
      begin
         if AP.Integer_Value (Name => "tasks") > 0 then
            Tasks := AP.Integer_Value (Name => "tasks");
         else
            Tasks := Natural (System.Multiprocessors.Number_Of_CPUs);
            Put_Line ("Detected: " & Natural'Image(Tasks) & " CPUs");
         end if;

         if Prog_Options.Unicode_Only_Mode = Prog_Options.Non_Unicode_Only_Mode and then
           Prog_Options.Unicode_Only_Mode = True then
            Put_Line("Unicode only mode incompatible with non-unicode only mode: " & AP.Parse_Message);
            AP.Usage;
            Status_Task.Early_Exit;

         elsif Input_Path'Length = 0 then
            Put_Line("Input file must be specified: " & AP.Parse_Message);
            AP.Usage;
            Status_Task.Early_Exit;
         else
            Status_Task.Receive_Access (Data => CA);
            Process_Main(Input_Path   => Input_Path,
                         Prog_Options => Prog_Options,
                         Tasks        => Tasks,
                         CA           => CA);

            CA.all.Print_Current;
            Status_Task.Print_And_Exit (File_Name => Output_String);
            Put_Line("Finished writing output");

         end if;
      end;

      End_Time := Clock;
      Diff := End_Time - Start_Time;
      Put_Line ("Total time taken: " & Duration'Image (To_Duration (Diff)) & "s");
   else
      Put_Line("Error while parsing command-line arguments: " & AP.Parse_Message);
      AP.Usage;
   end if;


end Main;
