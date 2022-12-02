import std;

@safe:

enum Choice : int
{
    Rock = 1,
    Paper = 2,
    Scissors = 3
}

Choice charToChoice(in char c) pure
{
    final switch (c)
    {
    case 'A':
        return Choice.Rock;
    case 'B':
        return Choice.Paper;
    case 'C':
        return Choice.Scissors;
    }
}

Choice choiceThatWinsFrom(in Choice other) pure
{
    return cast(Choice)((other % 3) + 1); // each choice beats the previous one in the row, so return the next one
}

Choice choiceThatLosesFrom(in Choice other)
{
    return choiceThatWinsFrom(choiceThatWinsFrom(other));
}

struct Round
{
    Choice player;
    Choice opponent;

    int score() const
    {
        int playerShapeScore = cast(int) player;

        int roundOutcome = 0;
        if (player == opponent) // draw
            roundOutcome = 3;
        else if (player == choiceThatWinsFrom(opponent))
            roundOutcome = 6;

        return playerShapeScore + roundOutcome;
    }

    static Round fromString(string s)
    {
        char opponentChar, outcomeChar;
        auto readCount = s.formattedRead!"%c %c"(opponentChar, outcomeChar);
        enforce(readCount == 2);

        Choice opponentChoice = opponentChar.charToChoice;
        Choice playerChoice;
        final switch (outcomeChar)
        {
        case 'X': // player must lose
            playerChoice = choiceThatLosesFrom(opponentChoice);
            break;
        case 'Y': // must be a draw
            playerChoice = opponentChoice;
            break;
        case 'Z': // player must win
            playerChoice = choiceThatWinsFrom(opponentChoice);
            break;
        }

        return Round(playerChoice, opponentChoice);
    }
}

void main() @system
{
    stdin.byLine
        .map!(roundLine => Round.fromString(cast(string) roundLine))
        .map!(round => round.score)
        .sum
        .writeln;
}
