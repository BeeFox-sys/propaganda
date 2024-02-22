WITH new_election AS (
    INSERT INTO "election" (
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
        'Sports Balls', 
        'Balls, for your sport!',
        '#ddcccc',
        'raffle',
        3,
        '01-01-2023', 
        '01-01-2025',
        '01-01-2023', 
        '01-01-2025'
    ) 
    RETURNING id
)  
INSERT INTO "item" (id, icon, name, description, color, election)
SELECT v.*, ne.id
FROM (
    VALUES 
        (1, '🥌', 'Curling Stone', 'Hard Hitting', '#bbbbee'),
        (2, '🥏', 'Disc',          'Fast Flying',  '#fa8a63'),
        (3, '🎱', 'Eight Ball',    'Lucky Shot',   '#666666'),
        (4, '🪀', 'YoYo',          'Rebound',      '#dd4444')
) AS v 
CROSS JOIN new_election ne;

INSERT INTO "update" (file_name) VALUES ('.test_1.sql');