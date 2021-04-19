-- Adapted from https://rosettacode.org/wiki/Bitcoin/address_validation#Ada
with Ada.Exceptions; use Ada.Exceptions;
with Interfaces;     use Interfaces;
with Ada.Streams;    use Ada.Streams;

generic
   Stream_Length : Positive;
package Base58 is

   subtype Base58_Raw_Type is Stream_Element_Array(1 .. Stream_Element_Offset(Stream_Length));
   Invalid_Address_Error : Exception;
   
   procedure Decode (S : String; R : out Base58_Raw_Type);

private
   Base58_Values : constant String := "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"; 
end Base58;
