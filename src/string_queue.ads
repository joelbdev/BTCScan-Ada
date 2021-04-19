with Ada.Containers.Unbounded_Synchronized_Queues;
use Ada.Containers;
with String_Queue_Interface;

package String_Queue is new Unbounded_Synchronized_Queues(Queue_Interfaces => String_Queue_Interface);
