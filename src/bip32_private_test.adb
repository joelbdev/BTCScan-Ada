with Ada.Text_IO; use Ada.Text_IO;
with BIP32_Private; use BIP32_Private;

procedure BIP32_Private_Test is
   S1 : String := "xprv9s21ZrQH143K24Mfq5zL5MhWK9hUhhGbd45hLXo2Pq2oqzMMo63oStZzF93Y5wvzdUayhgkkFoicQZcP3y52uPPxFnfoLZB21Teqt1VvEHx";
   S2 : String := "5HueCGU8rMjxEXxiPuD5BDku4MkFqeZyd4dZ1jvhTVqvbTLvyTJ";
   S3 : String := "5Hwgr3u458GLafKBgxtssHSPqJnYoGrSzgQsPwLFhLNYskDPyyA";
   S4 : String := "L1aW4aubDFB7yfras2S1mN3bqg9nwySY8nkoLmJebSLD5BWv3ENZ";
   S5 : String := "1A Na15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i";
   S6 : String := "17VZNX1SN5NtKa8UQFxwQbFeFc3iqRYhem";
   S7 : String := "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i";
   S8 : String := "1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nK9";
   S9 : String := "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62X";
   SA : String := "1ANNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i";
begin
   Put_Line ("Test 1: " & S1 & " - " & Boolean'Image (Validate (S => S1)));
   Put_Line ("Test 2: " & S2 & " - " & Boolean'Image (not Validate (S => S2)));
   Put_Line ("Test 3: " & S3 & " - " & Boolean'Image (not Validate (S => S3)));
   Put_Line ("Test 4: " & S4 & " - " & Boolean'Image (not Validate (S => S4)));
   Put_Line ("Test 5: " & S5 & " - " & Boolean'Image (not Validate (S => S5)));
   Put_Line ("Test 6: " & S6 & " - " & Boolean'Image (not Validate (S => S6)));
   Put_Line ("Test 7: " & S7 & " - " & Boolean'Image (not Validate (S => S7)));
   Put_Line ("Test 8: " & S8 & " - " & Boolean'Image (not Validate (S => S8)));
   Put_Line ("Test 9: " & S9 & " - " & Boolean'Image (not Validate (S => S9)));
   Put_Line ("Test A: " & SA & " - " & Boolean'Image (not Validate (S => SA)));
end BIP32_Private_Test;