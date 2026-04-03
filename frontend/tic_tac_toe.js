const boardElement = document.getElementById('board');
const statusElement = document.getElementById('status');
const resetButton = document.getElementById('resetBtn');
const scoreX = document.getElementById('scoreX');
const scoreO = document.getElementById('scoreO');
const scoreTie = document.getElementById('scoreTie');

let boardState = Array(9).fill('');
let currentPlayer = 'X';
let isGameActive = true;
let winCounts = { X: 0, O: 0, Tie: 0 };

const winningPatterns = [
  [0,1,2], [3,4,5], [6,7,8],
  [0,3,6], [1,4,7], [2,5,8],
  [0,4,8], [2,4,6]
];

function updateStatus(message) { statusElement.textContent = message; }
function updateScores() {
  scoreX.textContent = `X: ${winCounts.X}`;
  scoreO.textContent = `O: ${winCounts.O}`;
  scoreTie.textContent = `Tie: ${winCounts.Tie}`;
}

function markCell(cell, index) {
  if (!isGameActive || boardState[index]) return;
  boardState[index] = currentPlayer;
  cell.classList.add(currentPlayer.toLowerCase());
  cell.textContent = currentPlayer;
  cell.removeEventListener('click', onCellClick);

  const winner = checkWin();
  if (winner) {
    isGameActive = false;
    winCounts[winner] += 1;
    highlightWinningPattern(winner);
    updateStatus(`Winner: ${winner} 🎉`);
    updateScores();
    return;
  }

  if (boardState.every(value => value)) {
    isGameActive = false;
    winCounts.Tie += 1;
    updateStatus('Draw! 🤝');
    updateScores();
    return;
  }

  currentPlayer = currentPlayer === 'X' ? 'O' : 'X';
  updateStatus(`Turn: ${currentPlayer}`);
}

function onCellClick(event) {
  const cell = event.target;
  const index = parseInt(cell.dataset.index, 10);
  markCell(cell, index);
}

function checkWin() {
  for (const validPattern of winningPatterns) {
    const [a, b, c] = validPattern;
    if (boardState[a] && boardState[a] === boardState[b] && boardState[a] === boardState[c]) {
      return boardState[a];
    }
  }
  return null;
}

function highlightWinningPattern(winner) {
  for (const pattern of winningPatterns) {
    const [a, b, c] = pattern;
    if (boardState[a] === winner && boardState[b] === winner && boardState[c] === winner) {
      [a, b, c].forEach(idx => boardElement.children[idx].classList.add('win'));
      break;
    }
  }
}

function initBoard() {
  boardElement.innerHTML = '';
  boardState = Array(9).fill('');
  isGameActive = true;
  currentPlayer = 'X';
  updateStatus('Turn: X');

  for (let i = 0; i < 9; i++) {
    const cell = document.createElement('div');
    cell.className = 'cell';
    cell.dataset.index = i;
    cell.addEventListener('click', onCellClick);
    boardElement.appendChild(cell);
  }
}

resetButton.addEventListener('click', initBoard);
updateScores();
initBoard();
