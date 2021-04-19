with Ada.Text_IO; use Ada.Text_IO;
with P2SH; use P2SH;

procedure P2SH_Test is
   S1 : String := "3AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i";
   S2 : String := "3Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nK9";
   S3 : String := "3AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62X";
   S4 : String := "3ANNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i";
   S5 : String := "3A Na15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i";
   S6 : String := "37VZNX1SN5NtKa8UQFxwQbFeFc3iqRYhem";
   S7 : String := "3EktnHQD7RiAE6uzMj2ZifT9YgRrkSgzQX";
begin
   Put_Line ("Test 1: " & S1 & " - " & Boolean'Image (not Validate (S => S1)));
   Put_Line ("Test 2: " & S2 & " - " & Boolean'Image (not Validate (S => S2)));
   Put_Line ("Test 3: " & S3 & " - " & Boolean'Image (not Validate (S => S3)));
   Put_Line ("Test 4: " & S4 & " - " & Boolean'Image (not Validate (S => S4)));
   Put_Line ("Test 5: " & S5 & " - " & Boolean'Image (not Validate (S => S5)));
   Put_Line ("Test 6: " & S6 & " - " & Boolean'Image (not Validate (S => S6)));
   Put_Line ("Test 7: " & S7 & " - " & Boolean'Image (Validate (S => S7)));
end P2SH_Test;
