with Options; use Options;
with Common_Data; use Common_Data;
with Worker_Tasks;

package Process is
   type Tasks_Array_Type is array (Natural range <>) of Worker_Tasks.Worker_Task;
      
   procedure Process_Main(Input_Path   : String;
                          Prog_Options : Options_Type;
                          Tasks        : Natural;
                          CA           : Common_Access) with
     Pre => (not (Prog_Options.Unicode_Only_Mode = True 
             and then Prog_Options.Non_Unicode_Only_Mode = True)
             and Input_Path'Length > 0 and Tasks > 0);
   -- Given input path, options, the number of tasks, and access to common data,
   -- start iterating through directories searching for files to add to a queue
   -- for the tasks to draw file names from

end Process;
