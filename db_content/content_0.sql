INSERT INTO "team" (id, color, icon, name, subtitle)
  VALUES 
    (1, '#ad4943', '🪐', 'Celestial Pirates', 'Plunder the skys'),
    (2, '#dfa353', '🕳️', 'Abyssal Leviathans', 'From Down Below'),
    (3, '#ddd05b', '🌌', 'Cosmic Wisps', 'Hold your souls'),
    (4, '#45ad4a', '🏜️', 'Dune Wanderers', 'The desert we roam'),
    (5, '#7697dc', '🎲', 'Quantum Phantoms', 'Falling through time'),
    (6, '#e280b5', '🏹', 'Starlight Archers', 'Forming a home');

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
        'Sports Balls', 
        'Balls, for your sport!',
        '#bdf796',
        'raffle',
        '26-02-2024', 
        '04-03-2024',
        '02-03-2024', 
        '03-03-2024'
    ) 
    RETURNING id
)  
INSERT INTO "item" (icon, name, description, color, election)
SELECT v.*, ne.id
FROM (
    VALUES 
        ('🥌', 'Curling Stone', 'Hard Hitting', '#a3a3ff'),
        ('🥏', 'Disc',          'Fast Flying',  '#f9ae7f'),
        ('🎱', 'Eight Ball',    'Lucky Shot',   '#c89ff4'),
        ('🪀', 'YoYo',          'Rebound',      '#ef7c91'),
        ('🍙', 'Rice Ball',     'Sticky',       '#fffcbf'),
        ('🪩', 'Disco Ball',    'Distraction!', '#9ab9ed')
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
        'Gravity', 
        'Directions',
        '#bb88bb',
        'majority',
        '26-02-2024', 
        '04-03-2024',
        '02-03-2024', 
        '03-03-2024'
    ) 
    RETURNING id
)  
INSERT INTO "item" (icon, name, description, color, election)
SELECT v.*, ne.id
FROM (
    VALUES 
        ('⬆️', 'Up',    '[UP] Gravity',    '#3c2e7f'),
        ('⬇️', 'Down',  '[DOWN] Gravity',  '#5a45bf'),
        ('⬅️', 'Left',  '[LEFT] Gravity',  '#b769c1'),
        ('➡️', 'Right', '[RIGHT] Gravity', '#f77684'),
        ('🔼', 'Forward', '[FORWARD] Gravity', '#ef9381'),
        ('🔽', 'Backward', '[BACKWARD] Gravity', '#fde174')
) AS v 
CROSS JOIN new_election ne;

INSERT INTO "update" (file_name) VALUES ('content_0.sql');
