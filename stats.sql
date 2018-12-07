CREATE OR REPLACE VIEW public.stat_base AS
 SELECT ca.card_id AS a,
    ca.count AS count_a,
    cb.card_id AS b,
    cb.count AS count_b,
    p.count as count_ab,
    t.total,
    na.card_name AS card_a,
    nb.card_name AS card_b
   FROM 
            card_count ca
       JOIN cards na ON (ca.card_id = na.card_id)
       ,
            card_count cb
       JOIN cards nb ON (cb.card_id = nb.card_id)
       ,
       public.pair_count p,
       ( SELECT count(*) AS count
           FROM public.cubes) t(total)
   WHERE
     (ca.card_id=p.a and cb.card_id=p.b) OR (ca.card_id=p.b and cb.card_id=p.a)

;


-- CREATE OR REPLACE VIEW public.real_stat_base AS
--  SELECT ca.card_id AS a,
--     ca.count AS count_a,
--     cb.card_id AS b,
--     cb.count AS count_b,
--     public.pair_count(a.card_id, b.card_id) AS count_ab,
--     t.total,
--     na.card_name AS card_a,
--     nb.card_name AS card_b
--    FROM (((((public.cube_card a
--      JOIN public.card_count ca ON ((a.card_id = ca.card_id)))
--      JOIN public.cards na ON ((a.card_id = na.card_id)))
--      JOIN public.cube_card b USING (cube_id))
--      JOIN public.card_count cb ON ((b.card_id = cb.card_id)))
--      JOIN public.cards nb ON ((b.card_id = nb.card_id))),
--     ( SELECT count(*) AS count
--            FROM public.cubes) t(total)
--   WHERE (a.cube_id = 121686);


CREATE OR REPLACE VIEW public.stat_p AS
 SELECT stat_base.a,
    stat_base.count_a,
    stat_base.b,
    stat_base.count_b,
    stat_base.count_ab,
    stat_base.total,
    stat_base.card_a,
    stat_base.card_b,
    (((stat_base.count_a)::numeric * 100.0) / (stat_base.total)::numeric) AS p_a,
    (((stat_base.count_b)::numeric * 100.0) / (stat_base.total)::numeric) AS p_b,
    (((stat_base.count_ab)::numeric * 100.0) / (stat_base.total)::numeric) AS p_ab
   FROM public.stat_base;

DROP view public.stat_score ;
CREATE OR REPLACE VIEW public.stat_score AS
 SELECT 
    round((count_ab*100.0/count_a) - p_b,3) as "(q(ab)/q(a)) - p(b)",
    round(((((2 * stat_p.count_ab))::numeric * 100.0) / ((stat_p.count_a + stat_p.count_b))::numeric), 3) as "2q(AB)/(q(A)+q(B))" ,
    round((((stat_p.count_ab)::numeric * 100.0) / (LEAST(stat_p.count_a, stat_p.count_b))::numeric), 3) as "q(AB)/min(q(A),q(B))",
    stat_p.card_a,
    stat_p.card_b,
    stat_p.count_a AS qa,
    stat_p.count_b AS qb,
    stat_p.count_ab AS qab,
    round(stat_p.p_a, 3) AS pa,
    round(stat_p.p_b, 3) AS pb,
    round(stat_p.p_ab, 3) AS pab,
    stat_p.a,
    stat_p.b
   FROM public.stat_p
  WHERE (stat_p.a <> stat_p.b);
