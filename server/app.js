const express = require("express");
const { getConnection, oracledb } = require("./db");
const cors = require("cors");
const OracleDB = require("oracledb");
const app = express(); // 익스프레스 모듈을 활용 실체 기능.
app.use(express.static(__dirname));

// 셋업 추가. CORS
app.use(cors()); // CORS 요청 처리.
app.use(express.json()); //body 영역에 json 처리.

// url 정보 -> 실행기능. 라우팅.
app.get("/", (req, res) => {
  res.send("OK");
});
// 글목록 조회.
app.get("/board/:page", async (req, res) => {
  const page = req.params.page;
  const conn = await getConnection();
  const { metaData, rows } = await conn.execute(
    `  select *
         from board
         order by board_no
         offset (:page - 1) * 10 rows fetch next 10 rows only`,
    { page },
  );
  const json = JSON.stringify(rows); // 객체 -> json 문자열.
  res.json(rows);
  // res.send(json); // 응답처리.
});
// 글삭제.
app.get("/board_delete/:bno", async (req, res) => {
  console.log(req.params.bno); // req.params 속성.
  const conn = await getConnection();
  const result = await conn.execute(
    `DELETE FROM board WHERE board_no = :bno`,
    { bno: req.params.bno },
    { autoCommit: true },
  );
  console.log(result.outBinds.bno[0]);

  // 정상 삭제되면 OK, 삭제 못하면 NG
  if (result.rowsAffected) {
    res.json({ retCode: "OK" }); // {"retCode": "OK" }
  } else {
    res.json({ retCode: "NG" });
  }
  // const json = JSON.stringify(rows); // 객체 -> json 문자열.
  res.send(result); // 응답처리.
});

// 수정.
app.get("/board_update/:bno/:title/:content", async (req, res) => {
  console.log(req.params); // req.params 속성.
  const conn = await getConnection();
  const result = await conn.execute(
    `update board
      set title = :title
        , content = :content
    where board_no = :bno`,
    {
      bno: req.params.bno,
      title: req.params.title,
      content: req.params.content,
    },
    { autoCommit: true },
  );
  // 정상 삭제되면 OK, 삭제 못하면 NG
  if (result.rowsAffected) {
    res.json({ retCode: "OK" }); // {"retCode": "OK" }
  } else {
    res.json({ retCode: "NG" });
  }
  // const json = JSON.stringify(rows); // 객체 -> json 문자열.
  res.send(result); // 응답처리.
});

// 등록.
app.post("/board_insert", async (req, res) => {
  console.log(req.body); // req.params 속성.
  const { title, content, writer } = req.body;
  const conn = await getConnection();
  const result = await conn.execute(
    `insert into board(board_no, title, writer, content)
     values((select nvl(max(board_no),0)+1 from board),:title,:writer,:content)
     returning board_no into :bno`,
    {
      bno: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER },
      title,
      content,
      writer,
    },
    { autoCommit: true },
  );

  console.log(result.outBinds.bno[0]);
  // 정상 삭제되면 OK, 삭제 못하면 NG
  if (result.rowsAffected) {
    res.json({
      retCode: "OK",
      BOARD_NO: result.outBinds.bno[0],
      TITLE: title,
      WRITER: writer,
      CONTENT: content,
    }); // {"retCode": "OK" }
  } else {
    res.json({ retCode: "NG" });
  }
  // const json = JSON.stringify(rows); // 객체 -> json 문자열.
});

app.listen(3000, () => {
  console.log("http://localhost:3000");
}); // 서버 실행. (3000번 포트)
