with Base58;
with Ada.Streams; use Ada.Streams;

package WIFUPK is
      
   function Validate (S : String) return Boolean;
   
private
   subtype BT_Checksum is Stream_Element_Array (1 .. 4);
   
   function Double_Sha256 (S : Stream_Element_Array) return BT_Checksum;
   
end WIFUPK;
