with Ada.Text_IO; use Ada.Text_IO;
with Base58;
with Ada.Streams; use Ada.Streams;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Base58_Test is
   package BTC_Base58 is new Base58(Stream_Length => 25);

   S1 : String := "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i";
   S2 : String := "1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nK9";
   S3 : String := "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62X";
   S4 : String := "1ANNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i";
   S5 : String := "1A Na15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i";

   T1 : String := " 0 101 161 96 89 134 74 47 219 199 201 154 71 35 168 57 91 198 241 136 235 192 70 178 255";
   T2 : String := " 0 252 114 80 162 17 222 221 199 14 229 162 115 141 229 240 120 23 53 28 239 144 223 250 184";
   T3 : String := " 0 101 161 96 89 134 74 47 219 199 201 154 71 35 168 57 91 198 241 136 235 192 70 178 244";
   T4 : String := " 0 102 195 223 68 91 1 248 112 110 110 28 12 102 150 234 7 21 237 13 10 192 70 178 255";


   function Stream_Image (I : BTC_Base58.Base58_Raw_Type) return String is
      Full : Unbounded_String;
   begin
      for C in I'Range loop
         Append (Source   => Full,
                 New_Item => Stream_Element'Image(I(C)));
      end loop;
      return To_String (Full);
   end Stream_Image;

   function Test_String (Input_String : String; Test_S : String) return Boolean is
      Result : BTC_Base58.Base58_Raw_Type;
   begin
      BTC_Base58.Decode(S => Input_String,
                        R => Result);
      declare
         RImage : String := Stream_Image (I => Result);
      begin
         return RImage = Test_S;
      end;
   exception
      when others =>
         return False;
   end Test_String;

   procedure Test_Base58 (I : Integer; I_String : String; T_String : String; Assert : Boolean) is
      Result : Boolean := Test_String (Input_String => I_String,
                                       Test_S       => T_String);

   begin
      if Result = Assert then
         Put_Line ("Test" & Integer'Image (I) & ": Success");
      else
         Put_Line ("Test" & Integer'Image (I) & ": Failed");
      end if;
   end Test_Base58;

begin
   Test_Base58 (I        => 1,
                I_String => S1,
                T_String => T1,
                Assert   => True);
   Test_Base58 (I        => 2,
                I_String => S2,
                T_String => T2,
                Assert   => True);
   Test_Base58 (I        => 3,
                I_String => S3,
                T_String => T3,
                Assert   => True);
   Test_Base58 (I        => 4,
                I_String => S4,
                T_String => T4,
                Assert   => True);
   Test_Base58 (I        => 5,
                I_String => S5,
                T_String => "",
                Assert   => False);
end Base58_Test;
