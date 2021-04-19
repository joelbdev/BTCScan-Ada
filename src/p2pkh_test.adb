with Ada.Text_IO; use Ada.Text_IO;
with P2PKH; use P2PKH;

procedure P2PKH_Test is
   S1 : String := "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i";
   S2 : String := "1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nK9";
   S3 : String := "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62X";
   S4 : String := "1ANNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i";
   S5 : String := "1A Na15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i";
   S6 : String := "17VZNX1SN5NtKa8UQFxwQbFeFc3iqRYhem";
begin
   Put_Line ("Test 1: " & S1 & " - " & Boolean'Image (Validate (S => S1)));
   Put_Line ("Test 2: " & S2 & " - " & Boolean'Image (Validate (S => S2)));
   Put_Line ("Test 3: " & S3 & " - " & Boolean'Image (not Validate (S => S3)));
   Put_Line ("Test 4: " & S4 & " - " & Boolean'Image (not Validate (S => S4)));
   Put_Line ("Test 5: " & S5 & " - " & Boolean'Image (not Validate (S => S5)));
   Put_Line ("Test 6: " & S6 & " - " & Boolean'Image (Validate (S => S6)));
end P2PKH_Test;
