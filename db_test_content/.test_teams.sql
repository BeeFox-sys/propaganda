INSERT INTO "team" (id, color, icon, name, subtitle)
  VALUES 
    (1, '#ad4943', '🔴', 'Red Team', 'We are the red team!'),
    (2, '#dfa353', '🟠', 'Orange Team', 'We are the orange team!'),
    (3, '#ddd05b', '🟡', 'Yellow Team', 'We are the yellow team!'),
    (4, '#45ad4a', '🟢', 'Green Team', 'We are the green team! '),
    (5, '#7697dc', '🔵', 'Blue Team', 'We are the blue team!'),
    (6, '#e280b5', '🟣', 'Purple Team', 'We are the purple team!');


WITH new_election AS (
    INSERT INTO "election" (
        id,
        title,
        subtitle,
        color,
        mode,
        votes_per_user,
        display_start, 
        display_end,
        vote_start,
        vote_end
    ) 
    VALUES (
        3,
        'Directions 2', 
        '',
        '#66aaff',
        'majority',
        3,
        '01-01-2023', 
        '01-01-2023',
        '01-01-2023', 
        '01-01-2023'
    ) 
    RETURNING id
)  
INSERT INTO "item" (id, icon, name, description, color, winner, election)
SELECT v.*, ne.id
FROM (
    VALUES 
        (5, '⬆️', 'Up',    'The UP',    '#3c2e7f', 1),
        (6, '⬇️', 'Down',  'The Down',  '#5a45bf', 2),
        (7, '⬅️', 'Left',  'The Left',  '#b769c1', 3),
        (8, '➡️', 'Right', 'The Right', '#f77684', 4),
        (9, '🔼', 'Foreward', 'The Foreward', '#ef9381', 5),
        (10, '🔽', 'Backward', 'The Backward', '#fde174', 6)
) AS v 
CROSS JOIN new_election ne;

INSERT INTO "vote" (user_id, election, item, team)
    select 0,3,floor(random() * 6 + 5)::int,0
    from generate_series(1, 350);


INSERT INTO "update" (file_name) VALUES ('.test_teams.sql');