with GNAT.Regpat; use GNAT.Regpat;
with Options; use Options;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Common_Data; use Common_Data;

package Scanner_Regex is
   
   Scanner_Program_Size : constant Program_Size := 1000;
   
   subtype Fixed_Matcher is Pattern_Matcher (Scanner_Program_Size);
   type Validation_Function is access function (S : String) return Boolean;
   type Found_Type_Enum is (Btc_Addr,
                            Btc_P2SH,
                            Bip38_Epk,
                            Wif_Upk,
                            Wif_Cpk,
                            Bip32_Prv,
                            Bip32_Pub);
   
   type Group_Type is record
      Pattern    : Unbounded_String;
      Byte_Len   : Natural;
      Found_Type : Found_Type_Enum;
      Unicode    : Boolean;
      Quick      : Boolean;
      Validate   : Validation_Function;
      Matcher    : Fixed_Matcher;
   end record;
   
   type Groups_Index is range 1..14;
   type Groups_Array is array (Groups_Index) of Group_Type;
   
   type Scanner_Class is record
      A : Groups_Array;
   end record;
   
   function To_String (Found_Type : Found_Type_Enum) return String;
   -- Convert bitcoin data type enumeration to string values
   
   function Remove_Zeros (S : String) return String with
     Post => Remove_Zeros'Result'Length <= S'Length;
   -- Removes zeros from a string, replacing them with nothing.
   
   
   function New_Group (Pattern    : String;
                       Byte_Len   : Natural;
                       Found_Type : Found_Type_Enum;
                       Unicode    : Boolean;
                       Quick      : Boolean;
                       Validate   : Validation_Function) return Group_Type;
   
   procedure Initialize_Scanner (Self : out Scanner_Class); --with
   --  Post => (for all ix in Groups_Index
   --           => Self.A(ix).Matcher /= null);
   
   procedure Scan (Scanner   : Scanner_Class;
                   Input     : String;
                   Opts      : Options_Type;
                   File_Name : String;
                   CAccess   : Common_Access);

end Scanner_Regex;
