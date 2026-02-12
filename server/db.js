const oracledb = require("oracledb");

// 결과물 -> 객체.
oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;

async function getConnection() {
  return await oracledb.getConnection({
    user: "scott",
    password: "tiger",
    connectString: "192.168.0.34:1521/xe",
  }); // 세션 가지고 오는 함수.
}
module.exports = { getConnection, oracledb };

// `insert into board (board_no, title, writer, content)
//                       values(:bno, :title, :writer, :content)`

// `update board
//    set title = :title
//       ,writer = :writer
//       ,content = :content
//     where board_no = :bno`

// const result = await conn.execute(
//   // execute 함수
//   `delete from board where board_no = :bno`,
//   {
//     //파라메타 입력 必!
//     bno: 20,
//     // title: "글등록연습20",
//     // writer: "user99",
//     // content: "글등록연습중입니다20",
//   },
//   { autoCommit: true }, // 세번째 옵션
// );
// // conn.commit();
// console.log(result);

// const { metaData, rows } = await conn.execute(`SELECT * FROM board`);
// console.log(rows); // {metaData:[], rows:[]}

// connectFunc();
