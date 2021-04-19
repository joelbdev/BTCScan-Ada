with Always_True;
with P2PKH;
with P2SH;
with WIFUPK;
with WIFCPK;
with BIP32_Private;
with BIP32_Public;

package body Scanner_Regex is
   
   function To_String (Found_Type : Found_Type_Enum) return String is
   begin
      case Found_Type is
         when Btc_Addr  => return "Bitcoin address";
         when Btc_P2SH  => return "Bitcoin P2SH";
         when Bip38_Epk => return "BIP38 Encrypted Private Key";
         when Wif_Upk   => return "WIF Private key, uncompressed public keys";
         when Wif_Cpk   => return "WIF Private key, compressed public keys";
         when Bip32_Pub => return "BIP32 HD walllet private node";
         when Bip32_Prv => return "BIP32 HD walllet public node";
      end case;
   end;
   
   function Remove_Zeros (S : String) return String is
      Zero_Count : Integer := 0;
   begin
      for I in S'Range loop
         if S (I) = '0' then
            Zero_Count := Zero_Count + 1;
         end if;
      end loop;
      declare
         New_String : String (S'First .. S'Last - Zero_Count);
         New_Index  : Natural := New_String'First;
      begin
         for I in S'Range loop
            if S (I) /= '0' then
               New_String (New_Index) := S (I);
               New_Index := Natural'Succ (New_Index);
            end if;
         end loop;
         return New_String;
      end;
   end;
   
   function New_Group (Pattern    : String;
                       Byte_Len   : Natural;
                       Found_Type : Found_Type_Enum;
                       Unicode    : Boolean;
                       Quick      : Boolean;
                       Validate   : Validation_Function) return Group_Type is
      Matcher : Fixed_Matcher;
   begin
      Compile(Matcher    => Matcher,
              Expression => Pattern);
      
      return (To_Unbounded_String (Pattern),
              Byte_Len,
              Found_Type,
              Unicode,
              Quick,
              Validate,
              Matcher);
   end;
   
   procedure Initialize_Scanner (Self : out Scanner_Class) is
      Arr : constant Groups_Array :=
      --            Pattern                                    Len  Type       Utf    Quick  Validation function      
        (New_Group ("1[a-km-zA-HJ-NP-Z1-9]{25,34}",             25, Btc_Addr,  False, True,  P2PKH.Validate'Access),
         New_Group ("1(0[a-km-zA-HJ-NP-Z1-9]){25,34}",          25, Btc_Addr,  True,  True,  P2PKH.Validate'Access),
         New_Group ("3[a-km-zA-HJ-NP-Z1-9]{25,34}",             25, Btc_P2SH,  False, True,  P2SH.Validate'Access),
         New_Group ("3(0[a-km-zA-HJ-NP-Z1-9]){25,34}",          25, Btc_P2SH,  True,  True,  P2SH.Validate'Access),
         New_Group ("6P[a-km-zA-HJ-NP-Z1-9]{56}",               43, Bip38_Epk, False, True,  Always_True.Validate_Always_True'Access),
         New_Group ("60P(0[a-km-zA-HJ-NP-Z1-9]){56}",           43, Bip38_Epk, True,  True,  Always_True.Validate_Always_True'Access),
         New_Group ("5[a-km-zA-HJ-NP-Z1-9]{50}",                37, Wif_Upk,   False, True,  WIFUPK.Validate'Access),
         New_Group ("5(0[a-km-zA-HJ-NP-Z1-9]){50}",             37, Wif_Upk,   True,  True,  WIFUPK.Validate'Access),
         New_Group ("[KL][a-km-zA-HJ-NP-Z1-9]{51}",             38, Wif_Cpk,   False, True,  WIFCPK.Validate'Access),
         New_Group ("[KL](0[a-km-zA-HJ-NP-Z1-9]){51}",          38, Wif_Cpk,   True,  True,  WIFCPK.Validate'Access),
         New_Group ("xprv[a-km-zA-HJ-NP-Z1-9]{107,108}",        82, Bip32_Prv, False, False, BIP32_Private.Validate'Access),
         New_Group ("x0p0r0v(0[a-km-zA-HJ-NP-Z1-9]){107,108}",  82, Bip32_Prv, True,  False, BIP32_Private.Validate'Access),
         New_Group ("xpub[a-km-zA-HJ-NP-Z1-9]{107,108}",        82, Bip32_Pub, False, False, BIP32_Public.Validate'Access),
         New_Group ("x0p0u0b(0[a-km-zA-HJ-NP-Z1-9]){107,108}",  82, Bip32_Pub, True,  False, BIP32_Public.Validate'Access));

   begin
      Self := (A => Arr);
   end Initialize_Scanner;
   
   procedure Scan(Scanner   : Scanner_Class;
                  Input     : String;
                  Opts      : Options_Type;
                  File_Name : String;
                  CAccess   : Common_Access) is
      MA            : Match_Array (0..1);
      Start_Value   : Integer        := -1;
      More_Matches  : Boolean        := True;
   begin
      for I in Groups_Index loop
         if Opts.Quick_Mode and not Scanner.A(I).Quick then
            null;
         elsif Opts.Unicode_Only_Mode and not Scanner.A(I).Unicode then
            null;
         elsif Opts.Non_Unicode_Only_Mode and Scanner.A(I).Unicode then
            null;
         else
            Match_Loop:
            while More_Matches loop
               Match(Self       => Scanner.A(I).Matcher,
                     Data       => Input,
                     Matches    => MA,
                     Data_First => Start_Value);
               if MA(0) = No_Match then
                  More_Matches := False;
               else
                  declare
                     Found_String      : constant String              := Input (MA(0).First .. MA(0).Last);
                     Found_Type        : constant Found_Type_Enum     := Scanner.A (I).Found_Type;
                     Validate          : constant Validation_Function := Scanner.A (I).Validate;
                     
                     Normalised_String : constant String              := Remove_Zeros (Found_String);
                  begin                     
                     if Validate.all (Normalised_String) then
                        CAccess.all.Add_Scan_Result (File_Name   => File_Name,
                                                     Found_String => Normalised_String,
                                                     Found_Type   => To_String (Found_Type));
                     end if;
                  end;
               end if;
               --Put_Line ("Match found: Starting at: " & Integer'Image(MA(0).First) & ", Finishing at: " & Positive'Image(MA(0).Last));
               Start_Value := MA(0).Last;
            end loop Match_Loop;
            More_Matches := True;
            Start_Value := -1;
         end if;
      end loop;
   end;
  
end Scanner_Regex;
