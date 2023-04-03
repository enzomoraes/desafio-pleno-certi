import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

@Schema()
export class UserEntity {
  @Prop()
  _id: String;

  @Prop()
  name: String;

  @Prop()
  login: String;

  @Prop()
  password: String;

  @Prop()
  timestamp: number;
}

export const UserSchema = SchemaFactory.createForClass(UserEntity);
