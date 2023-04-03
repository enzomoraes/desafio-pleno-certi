import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Schema as S } from 'mongoose';

@Schema()
export class LogEntity {
  @Prop()
  _id: String;

  @Prop()
  action: string;

  @Prop()
  payload: S.Types.Mixed;

  @Prop()
  timestamp: number;
}

export const LogSchema = SchemaFactory.createForClass(LogEntity);
