use irl_tests;

-- We should be able to make a nice table joining up all the rows in each table
select b.id as row, b.description as b_desc, c.description as c_desc, d.description as d_desc, e.description as e_desc, f.description as f_desc
  from b
  left join c on b.id = c.id
  left join d on b.id = d.id
  left join e on b.id = e.id
  left join f on b.id = f.id;