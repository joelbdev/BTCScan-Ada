# BTCScan-Ada

Search for seed phrases and bitcoin addresses/private keys across a computer. High powered version written in ada. Doesn't write to the stack in order to speed up searching operations.

Credit to Chris Cohen for base version.


Reqires parse args to be created in a parse_args directory: https://github.com/jhumphry/parse_args 
You need GNAT studio to compile with gprbuild -P btcscan.gpr
Requires a directory called obj to dump the compiled files into.
