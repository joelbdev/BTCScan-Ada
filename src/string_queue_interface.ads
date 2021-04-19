with Ada.Containers.Synchronized_Queue_Interfaces;
use Ada.Containers;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package String_Queue_Interface is new Synchronized_Queue_Interfaces(Element_Type => Unbounded_String);
