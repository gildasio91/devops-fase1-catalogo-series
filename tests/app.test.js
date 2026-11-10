const test = require('node:test');
const assert = require('node:assert/strict');
const app = require('../src/app');

async function withServer(callback) {
  const server = app.listen(0);
  await new Promise((resolve) => server.once('listening', resolve));
  const address = server.address();
  const baseUrl = `http://127.0.0.1:${address.port}`;

  try {
    await callback(baseUrl);
  } finally {
    await new Promise((resolve, reject) =>
      server.close((error) => error ? reject(error) : resolve())
    );
  }
}

test('GET /health retorna status ok', async () => {
  await withServer(async (baseUrl) => {
    const response = await fetch(`${baseUrl}/health`);
    const body = await response.json();
    assert.equal(response.status, 200);
    assert.equal(body.status, 'ok');
  });
});

test('GET /series lista as séries cadastradas', async () => {
  await withServer(async (baseUrl) => {
    const response = await fetch(`${baseUrl}/series`);
    const body = await response.json();
    assert.equal(response.status, 200);
    assert.ok(Array.isArray(body));
    assert.ok(body.length >= 2);
  });
});

test('GET /series/:id retorna 404 para série inexistente', async () => {
  await withServer(async (baseUrl) => {
    const response = await fetch(`${baseUrl}/series/99999`);
    assert.equal(response.status, 404);
  });
});

test('POST /series cadastra uma série válida', async () => {
  await withServer(async (baseUrl) => {
    const response = await fetch(`${baseUrl}/series`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        title: 'Dark',
        genre: 'Suspense',
        seasons: 3
      })
    });
    const body = await response.json();
    assert.equal(response.status, 201);
    assert.equal(body.title, 'Dark');
    assert.equal(body.seasons, 3);
  });
});

test('POST /series rejeita dados inválidos', async () => {
  await withServer(async (baseUrl) => {
    const response = await fetch(`${baseUrl}/series`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ title: '', genre: 'Drama', seasons: 0 })
    });
    assert.equal(response.status, 400);
  });
});
