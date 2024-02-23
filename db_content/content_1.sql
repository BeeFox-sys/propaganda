WITH new_election AS (
    INSERT INTO "election" (
        title,
        subtitle,
        color,
        mode,
        display_start, 
        display_end,
        vote_start,
        vote_end
    ) 
    VALUES (
        'Form.', 
        'Become.',
        '#e8d559',
        'raffle',
        '2024-03-04', 
        '2024-03-11',
        '2024-03-09', 
        '2024-03-10'
    ) 
    RETURNING id
)  
INSERT INTO "item" (icon, name, description, color, election)
SELECT v.*, ne.id
FROM (
    VALUES 
        ('🩸', 'Blood',   'Drip', '#9b1a2b'),
        ('🍖', 'Flesh',   'Consume',  '#c1727c'),
        ('💀', 'Bone',    'Grow',   '#ede3c6'),
        ('👻', 'Soul',    'Inhabit',      '#dedded'),
        ('💡', 'Thought', 'Encompass',       '#c691ea'),
        ('🫂', 'Feel',    'Intrinsic', '#7e5bb7')
) AS v 
CROSS JOIN new_election ne;


WITH new_election AS (
    INSERT INTO "election" (
        title,
        subtitle,
        color,
        mode,
        display_start, 
        display_end,
        vote_start,
        vote_end
    ) 
    VALUES (
        'Time', 
        'All the time in the world...',
        '#faf1e2',
        'majority',
        '2024-03-04', 
        '2024-03-11',
        '2024-03-09', 
        '2024-03-10'
    ) 
    RETURNING id
)  
INSERT INTO "item" (icon, name, description, color, election)
SELECT v.*, ne.id
FROM (
    VALUES 
        ('➕', 'Positive',    'Time flows towards',    '#e3baaa'),
        ('➖', 'Negaitve',  'Time flows away',  '#538085'),
        ('📈', 'Upstream',  'Time flows up',  '#ffaa6a'),
        ('📉', 'Downstream', 'Time flows down', '#085578'),
        ('🛑', 'None', 'Time Stops', '#e47e8c')
) AS v 
CROSS JOIN new_election ne;

INSERT INTO "update" (file_name) VALUES ('content_1.sql');
