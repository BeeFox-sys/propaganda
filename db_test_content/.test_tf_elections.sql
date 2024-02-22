-- election id start at 4
WITH
    new_election AS (
        INSERT INTO
            "election" (
                id, title, subtitle, color, mode, votes_per_user, display_start, display_end, vote_start, vote_end
            )
        VALUES (
                4, 'Test Election One', 'Raffle 6 Items 6 Teams', '#ff0000', 'raffle', 1, '01-01-2023', '01-01-2025', '01-01-2023', '01-01-2023'
            ) RETURNING id
    )
INSERT INTO
    "item" (
        id, icon, name, description, color, election
    )
SELECT v.*, ne.id
FROM (
        VALUES (
                15, '🔴', 'One', 'One', '#ff0000'
            ), (
                16, '🟠', 'Two', 'Two', '#ff0000'
            ), (
                17, '🟡', 'Three', 'Three', '#ff0000'
            ), (
                18, '🟢', 'Four', 'Four', '#ff0000'
            ), (
                19, '🔵', 'Five', 'Five', '#ff0000'
            ), (
                20, '🟣', 'Six', 'Six', '#ff0000'
            )
    ) AS v
    CROSS JOIN new_election ne;

INSERT INTO "vote" (user_id, election, item, team)
    select 0,4,floor(random() * 6 + 15)::int,floor(random() * 6 + 1)::int
    from generate_series(1, 350);

WITH
    new_election AS (
        INSERT INTO
            "election" (
                id, title, subtitle, color, mode, votes_per_user, display_start, display_end, vote_start, vote_end
            )
        VALUES (
                5, 'Test Election Two', 'Raffle 4 Items 6 Teams', '#ffff00', 'raffle', 1, '01-01-2023', '01-01-2025', '01-01-2023', '01-01-2023'
            ) RETURNING id
    )
INSERT INTO
    "item" (
        id, icon, name, description, color, election
    )
SELECT v.*, ne.id
FROM (
        VALUES (
                21, '🔴', 'One', 'One', '#ffff00'
            ), (
                22, '🟠', 'Two', 'Two', '#ffff00'
            ), (
                23, '🟡', 'Three', 'Three', '#ffff00'
            ), (
                24, '🟢', 'Four', 'Four', '#ffff00'
            )
    ) AS v
    CROSS JOIN new_election ne;

INSERT INTO "vote" (user_id, election, item, team)
    select 0,5,floor(random() * 4 + 21)::int,floor(random() * 6 + 1)::int
    from generate_series(1, 350);

WITH
    new_election AS (
        INSERT INTO
            "election" (
                id, title, subtitle, color, mode, votes_per_user, display_start, display_end, vote_start, vote_end
            )
        VALUES (
                6, 'Test Election Three', 'Raffle 8 Items 6 Teams', '#ff00ff', 'raffle', 1, '01-01-2023', '01-01-2025', '01-01-2023', '01-01-2023'
            ) RETURNING id
    )
INSERT INTO
    "item" (
        id, icon, name, description, color, election
    )
SELECT v.*, ne.id
FROM (
        VALUES (
                25, '🔴', 'One', 'One', '#ff00ff'
            ), (
                26, '🟠', 'Two', 'Two', '#ff00ff'
            ), (
                27, '🟡', 'Three', 'Three', '#ff00ff'
            ), (
                28, '🟢', 'Four', 'Four', '#ff00ff'
            ), (
                29, '🔵', 'Five', 'Five', '#ff00ff'
            ), (
                30, '🟣', 'Six', 'Six', '#ff00ff'
            ), (
                31, '⚫', 'Seven', 'Seven', '#ff00ff'
            ), (
                32, '⚪', 'Eight', 'Eight', '#ff00ff'
            )
    ) AS v
    CROSS JOIN new_election ne;

INSERT INTO "vote" (user_id, election, item, team)
    select 0,6,floor(random() * 8 + 25)::int,floor(random() * 6 + 1)::int
    from generate_series(1, 350);

WITH
    new_election AS (
        INSERT INTO
            "election" (
                id, title, subtitle, color, mode, votes_per_user, display_start, display_end, vote_start, vote_end
            )
        VALUES (
                7, 'Test Election Four', 'Majority 4 Items', '#00ffff', 'majority', 1, '01-01-2023', '01-01-2025', '01-01-2023', '01-01-2023'
            ) RETURNING id
    )
INSERT INTO
    "item" (
        id, icon, name, description, color, election
    )
SELECT v.*, ne.id
FROM (
        VALUES (
                33, '🔴', 'One', 'One', '#00ffff'
            ), (
                34, '🟠', 'Two', 'Two', '#00ffff'
            ), (
                35, '🟡', 'Three', 'Three', '#00ffff'
            ), (
                36, '🟢', 'Four', 'Four', '#00ffff'
            )
    ) AS v
    CROSS JOIN new_election ne;

INSERT INTO "vote" (user_id, election, item, team)
    select 0,7,floor(random() * 4 + 33)::int,floor(random() * 6 + 1)::int
    from generate_series(1, 350);

WITH
    new_election AS (
        INSERT INTO
            "election" (
                id, title, subtitle, color, mode, votes_per_user, display_start, display_end, vote_start, vote_end
            )
        VALUES (
                8, 'Test Election Four', 'Not Displayed (future)', '#00ff00', 'raffle', 1, '01-01-2025', '01-01-2025', '01-01-2025', '01-01-2025'
            ) RETURNING id
    )
INSERT INTO
    "item" (
        id, icon, name, description, color, election
    )
SELECT v.*, ne.id
FROM (
        VALUES (
                37, '🔴', 'One', 'One', '#00ff00'
            ), (
                38, '🟠', 'Two', 'Two', '#00ff00'
            ), (
                39, '🟡', 'Three', 'Three', '#00ff00'
            ), (
                40, '🟢', 'Four', 'Four', '#00ff00'
            ), (
                41, '🔵', 'Five', 'Five', '#00ff00'
            ), (
                42, '🟣', 'Six', 'Six', '#00ff00'
            )
    ) AS v
    CROSS JOIN new_election ne;

INSERT INTO "vote" (user_id, election, item, team)
    select 0,8,floor(random() * 6 + 37)::int,floor(random() * 6 + 1)::int
    from generate_series(1, 350);

WITH
    new_election AS (
        INSERT INTO
            "election" (
                id, title, subtitle, color, mode, votes_per_user, display_start, display_end, vote_start, vote_end
            )
        VALUES (
                9, 'Test Election Five', 'Voting in future', '#00ff00', 'raffle', 1, '01-01-2023', '01-01-2025', '01-01-2025', '01-01-2025'
            ) RETURNING id
    )
INSERT INTO
    "item" (
        id, icon, name, description, color, election
    )
SELECT v.*, ne.id
FROM (
        VALUES (
                49, '🔴', 'One', 'One', '#00ff00'
            ), (
                50, '🟠', 'Two', 'Two', '#00ff00'
            ), (
                51, '🟡', 'Three', 'Three', '#00ff00'
            ), (
                52, '🟢', 'Four', 'Four', '#00ff00'
            ), (
                53, '🔵', 'Five', 'Five', '#00ff00'
            ), (
                54, '🟣', 'Six', 'Six', '#00ff00'
            )
    ) AS v
    CROSS JOIN new_election ne;

INSERT INTO "vote" (user_id, election, item, team)
    select 0,9,floor(random() * 6 + 49)::int,floor(random() * 6 + 1)::int
    from generate_series(1, 350);

WITH
    new_election AS (
        INSERT INTO
            "election" (
                id, title, subtitle, color, mode, votes_per_user, display_start, display_end, vote_start, vote_end
            )
        VALUES (
                10, 'Test Election Six', 'Voting in progress', '#00ff00', 'raffle', 1, '01-01-2023', '01-01-2025', '01-01-2023', '01-01-2025'
            ) RETURNING id
    )
INSERT INTO
    "item" (
        id, icon, name, description, color, election
    )
SELECT v.*, ne.id
FROM (
        VALUES (
                55, '🔴', 'One', 'One', '#00ff00'
            ), (
                56, '🟠', 'Two', 'Two', '#00ff00'
            ), (
                57, '🟡', 'Three', 'Three', '#00ff00'
            ), (
                58, '🟢', 'Four', 'Four', '#00ff00'
            ), (
                59, '🔵', 'Five', 'Five', '#00ff00'
            ), (
                60, '🟣', 'Six', 'Six', '#00ff00'
            )
    ) AS v
    CROSS JOIN new_election ne;

INSERT INTO "vote" (user_id, election, item, team)
    select 0,10,floor(random() * 6 + 55)::int,floor(random() * 6 + 1)::int
    from generate_series(1, 350);

WITH
    new_election AS (
        INSERT INTO
            "election" (
                id, title, subtitle, color, mode, votes_per_user, display_start, display_end, vote_start, vote_end
            )
        VALUES (
                11, 'Test Election Seven', 'Voting finished', '#00ff00', 'raffle', 1, '01-01-2023', '01-01-2025', '01-01-2023', '01-01-2023'
            ) RETURNING id
    )
INSERT INTO
    "item" (
        id, icon, name, description, color, election
    )
SELECT v.*, ne.id
FROM (
        VALUES (
                61, '🔴', 'One', 'One', '#00ff00'
            ), (
                62, '🟠', 'Two', 'Two', '#00ff00'
            ), (
                63, '🟡', 'Three', 'Three', '#00ff00'
            ), (
                64, '🟢', 'Four', 'Four', '#00ff00'
            ), (
                65, '🔵', 'Five', 'Five', '#00ff00'
            ), (
                66, '🟣', 'Six', 'Six', '#00ff00'
            )
    ) AS v
    CROSS JOIN new_election ne;

INSERT INTO "vote" (user_id, election, item, team)
    select 0,11,floor(random() * 6 + 61)::int,floor(random() * 6 + 1)::int
    from generate_series(1, 350);

WITH
    new_election AS (
        INSERT INTO
            "election" (
                id, title, subtitle, color, mode, votes_per_user, display_start, display_end, vote_start, vote_end
            )
        VALUES (
                12, 'Test Election Eight', 'Not Displayed (Passed)', '#00ff00', 'raffle', 1, '01-01-2023', '01-01-2023', '01-01-2023', '01-01-2023'
            ) RETURNING id
    )
INSERT INTO
    "item" (
        id, icon, name, description, color, election
    )
SELECT v.*, ne.id
FROM (
        VALUES (
                67, '🔴', 'One', 'One', '#00ff00'
            ), (
                68, '🟠', 'Two', 'Two', '#00ff00'
            ), (
                69, '🟡', 'Three', 'Three', '#00ff00'
            ), (
                70, '🟢', 'Four', 'Four', '#00ff00'
            ), (
                71, '🔵', 'Five', 'Five', '#00ff00'
            ), (
                72, '🟣', 'Six', 'Six', '#00ff00'
            )
    ) AS v
    CROSS JOIN new_election ne;

INSERT INTO "vote" (user_id, election, item, team)
    select 0,12,floor(random() * 6 + 67)::int,floor(random() * 6 + 1)::int
    from generate_series(1, 350);

WITH
    new_election AS (
        INSERT INTO
            "election" (
                id, title, subtitle, color, mode, votes_per_user, display_start, display_end, vote_start, vote_end
            )
        VALUES (
                13, 'Test Election Nine', 'No Votes', '#FFFFFF', 'raffle', 1, '01-01-2023', '01-01-2025', '01-01-2023', '01-01-2023'
            ) RETURNING id
    )
INSERT INTO
    "item" (
        id, icon, name, description, color, election
    )
SELECT v.*, ne.id
FROM (
        VALUES (
                73, '🔴', 'One', 'One', '#00ff00'
            ), (
                74, '🟠', 'Two', 'Two', '#00ff00'
            ), (
                75, '🟡', 'Three', 'Three', '#00ff00'
            ), (
                76, '🟢', 'Four', 'Four', '#00ff00'
            ), (
                77, '🔵', 'Five', 'Five', '#00ff00'
            ), (
                78, '🟣', 'Six', 'Six', '#00ff00'
            )
    ) AS v
    CROSS JOIN new_election ne;

    INSERT INTO "vote" (user_id, election, item, team)
    select 0,12,floor(random() * 6 + 67)::int,floor(random() * 6 + 1)::int
    from generate_series(1, 350);

WITH
    new_election AS (
        INSERT INTO
            "election" (
                id, title, subtitle, color, mode, votes_per_user, display_start, display_end, vote_start, vote_end
            )
        VALUES (
                14, 'Test Election Ten', 'No Votes, 8 items', '#FFFFFF', 'raffle', 1, '01-01-2023', '01-01-2025', '01-01-2023', '01-01-2023'
            ) RETURNING id
    )
INSERT INTO
    "item" (
        id, icon, name, description, color, election
    )
SELECT v.*, ne.id
FROM (
        VALUES (
                79, '🔴', 'One', 'One', '#00ff00'
            ), (
                80, '🟠', 'Two', 'Two', '#00ff00'
            ), (
                81, '🟡', 'Three', 'Three', '#00ff00'
            ), (
                82, '🟢', 'Four', 'Four', '#00ff00'
            ), (
                83, '🔵', 'Five', 'Five', '#00ff00'
            ), (
                84, '🟣', 'Six', 'Six', '#00ff00'
            ), (
                85, '⚫', 'Seven', 'Seven', '#ff00ff'
            ), (
                86, '⚪', 'Eight', 'Eight', '#ff00ff'
            )
    ) AS v
    CROSS JOIN new_election ne;

    WITH
    new_election AS (
        INSERT INTO
            "election" (
                id, title, subtitle, color, mode, votes_per_user, display_start, display_end, vote_start, vote_end
            )
        VALUES (
                15, 'Test Election Eleven', 'No Votes, 4 items', '#FFFFFF', 'raffle', 1, '01-01-2023', '01-01-2025', '01-01-2023', '01-01-2023'
            ) RETURNING id
    )
INSERT INTO
    "item" (
        id, icon, name, description, color, election
    )
SELECT v.*, ne.id
FROM (
        VALUES (
                87, '🔴', 'One', 'One', '#00ff00'
            ), (
                88, '🟠', 'Two', 'Two', '#00ff00'
            ), (
                89, '🟡', 'Three', 'Three', '#00ff00'
            ), (
                90, '🟢', 'Four', 'Four', '#00ff00'
            )
    ) AS v
    CROSS JOIN new_election ne;


        WITH
    new_election AS (
        INSERT INTO
            "election" (
                id, title, subtitle, color, mode, votes_per_user, display_start, display_end, vote_start, vote_end
            )
        VALUES (
                16, 'Test Election Twelve', 'Ends in 5 minutes', '#FFFFFF', 'raffle', 1, '01-01-2023', (now() + interval '10 minutes'), '01-01-2023', (now() + interval '5 minutes')
            ) RETURNING id
    )
INSERT INTO
    "item" (
        id, icon, name, description, color, election
    )
SELECT v.*, ne.id
FROM (
        VALUES (
                91, '🔴', 'One', 'From election 12', '#00ff00'
            ), (
                92, '🟠', 'Two', 'From election 12', '#00ff00'
            ), (
                93, '🟡', 'Three', 'From election 12', '#00ff00'
            ), (
                94, '🟢', 'Four', 'From election 12', '#00ff00'
            )
    ) AS v
    CROSS JOIN new_election ne;

INSERT INTO "update" (file_name) VALUES ('.test_tf_elections.sql');