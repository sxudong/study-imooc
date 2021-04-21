package design.pattern.creational.builder.example.builder;

import design.pattern.creational.builder.example.entity.Lego;

// 乐高套装构建器
public interface Builder {
	// 构建砖块
	Builder buildBrick();

	// 构建底板
	Builder buildPlate();

	// 构建瓦片
	Builder buildTile();

	// 构建齿轮
	Builder buildGear();

	Lego build();
}