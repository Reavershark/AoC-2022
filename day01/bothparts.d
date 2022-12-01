/+ dub.sdl:
+/
import std;

void main()
{
    int[] elfTotals = stdin
        .byLineCopy.array // read entire input
        .splitter([""]) // split on empty lines
        .map!(elfFood => elfFood.map!(to!int).sum)
        .array;

    writeln("Part 1: ", elfTotals.maxElement);

    writeln("Part 2: ", elfTotals.heapify.take(3).sum);
}
