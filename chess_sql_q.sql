SELECT DATA_TYPE from INFORMATION_SCHEMA.COLUMNS  where table_schema = 'chess' and table_name = 'chessgames';

# average number of moves until winning
SELECT AVG(turns - opening_ply) AS avg_moves_to_win
FROM chess.chessgames
WHERE victory_status IN ('mate', 'resign');

#which player is better to be black or white?
SELECT
  ROUND(COUNT(CASE WHEN winner = 'white' THEN 1 END) / COUNT(*) * 100, 2) AS white_win_rate,
  ROUND(COUNT(CASE WHEN winner = 'black' THEN 1 END) / COUNT(*) * 100, 2) AS black_win_rate
FROM chess.chessgames
WHERE victory_status = 'mate';

# 10 best game opning moves with the best win rate
SELECT 
  opening_name, 
  COUNT(*) AS game_count, 
  COUNT(CASE WHEN winner = 'white' OR winner = 'black' THEN 1 END) / COUNT(*) AS win_rate
FROM chess.chessgames
GROUP BY opening_name
ORDER BY win_rate DESC,game_count DESC
LIMIT 10;

#number of games played by each player
SELECT moves, COUNT(*) as losses
FROM chess.chessgames
WHERE victory_status = 'mate' and winner = 'black'
GROUP BY moves
ORDER BY losses DESC
LIMIT 10;


#best palyer
SELECT 
  ID,winner, 
  COUNT(*) AS win_count 
FROM chess.chessgames
GROUP BY ID,winner
ORDER BY win_count DESC 
LIMIT 1;

#distribution of game lengths
SELECT 
  CASE 
    WHEN turns <= 20 THEN '0-20' 
    WHEN turns <= 40 THEN '21-40' 
    WHEN turns <= 60 THEN '41-60' 
    ELSE '61+' 
  END AS game_turns_range, 
  COUNT(*) AS game_count 
FROM chess.chessgames
GROUP BY game_turns_range;

#most common opening moves for each player color
SELECT 
  winner, 
  opening_name, 
  opening_ply, 
  COUNT(*) AS game_count 
FROM chess.chessgames
GROUP BY winner, opening_name, opening_ply 
ORDER BY game_count DESC
LIMIT 10;
