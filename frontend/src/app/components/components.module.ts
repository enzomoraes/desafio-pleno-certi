import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NavbarComponent } from './navbar/navbar.component';
import { RouterModule } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';

@NgModule({
  declarations: [NavbarComponent, HomeComponent],
  imports: [CommonModule, RouterModule, MatCardModule, MatIconModule],
  exports: [NavbarComponent, HomeComponent],
})
export class ComponentsModule {}
