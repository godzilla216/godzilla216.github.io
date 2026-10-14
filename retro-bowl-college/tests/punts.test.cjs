const test = require('node:test');
const assert = require('node:assert/strict');
const { direction, formation, trajectory, landing, CONTACT } = require('../html5game/punts.js').logic;
test('career possession and end switches mirror punt direction; exhibition uses its selected direction', () => {
    for (const orientation of [-1, 1]) for (const human of [0, 1]) {
        assert.equal(direction(orientation, human, human, false), orientation);
        assert.equal(direction(orientation, 1 - human, human, false), -orientation);
        assert.equal(direction(orientation, 1 - human, human, true), orientation);
    }
});
test('mirrored formations have seven legal linemen, three protectors and a punter 14.5 yards deep', () => {
    for (const x of [320, 1000, 2280]) for (const dir of [-1, 1]) {
        const f = formation(x, dir), other = formation(2600 - x, -dir);
        assert.equal(f.kicking.length, 11); assert.equal(f.receiving.length, 11);
        assert.equal(f.kicking.filter(p => p.x === x).length, 7);
        assert.equal(f.kicking[0].x, Math.max(110, Math.min(2490, x - dir * 290)));
        if (x > 400 && x < 2200) assert.equal((x - f.kicking[0].x) * dir / 20, 14.5);
        assert(f.kicking.every(p => (p.x - x) * dir <= 0));
        for (const team of ['kicking', 'receiving']) f[team].forEach((p, i) => {
            assert.equal(other[team][i].x, 2600 - p.x); assert.equal(other[team][i].y, p.y);
            assert(p.y > 132 && p.y < 468);
        });
    }
});
test('punt speed matches normal kickoffs and landing prediction matches native drag and gravity', () => {
    for (const dir of [-1, 1]) for (const aim of [-25, 0, 25]) for (const power of [0.15, 0.65, 1]) {
        const t = trajectory(1000, 300, dir, aim, power,0.078);
        assert(t.dx * dir > 0); assert.equal(Math.sign(t.dy), Math.sign(aim));
        assert.equal(t.velocity,(50+Math.max(15,power*55))*.078*.7);
        const predicted=landing({x:1000,y:300,gmlvelocity:t.velocity,gmlzvel:t.zvel,gmlheight:CONTACT.height,gmldirec:Math.atan2(t.dy,t.dx)*180/Math.PI});
        let x=1000,y=300,height=CONTACT.height,velocity=t.velocity,z=t.zvel,frames=0;
        while(height>1&&frames<1000){velocity*=.9995;z-=.03;x+=t.dx/t.velocity*velocity;y+=t.dy/t.velocity*velocity;height+=z;frames++;}
        assert(Math.abs(frames-t.frames)<=1);
        assert(Math.hypot(x-predicted.x,y-predicted.y)<t.velocity+1e-6);
    }
});
